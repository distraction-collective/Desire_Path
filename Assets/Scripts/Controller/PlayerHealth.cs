using System.Collections;
using System.Collections.Generic;
using UnityEngine.Events;
using UnityEngine;
using RootMotion.Dynamics;
using RootMotion;
using StarterAssets;
using UnityEngine.InputSystem;
using UnityEngine.Rendering;

namespace DesirePaths
{
    public class PlayerHealth : MonoBehaviour
    {
        public PlayerDeathEvent PlayerDeathEvent;

        [Header("Events")]
        public UnityEvent m_OnCharacterDeath;

        [Header("Current parameters")]
        [SerializeField] private bool dead;
        [SerializeField] private bool safe;
        [SerializeField] private bool onSafeSpace;
        public ThirdPersonController _thirdPersonController;
        public CharacterController _characterController;
        public PlayerInput _playerInputs;
        public Transform t_checkLayerTransform;
        public GutsProximity _proximityDetector;
        public CadaverGutsManager _cadaverManager;

        private RaycastHit _hit;
        [Header("UI/UX Feedbacks")]
        public bool allowColorChange = true;
        public ParticleSystem _groundHealPS;
        public PuppetMaster _puppetMaster;
        public Animator _controllerAnimator;
        public SkinnedMeshRenderer _organsRenderer;
        public SkinnedMeshRenderer _bodyRenderer;
        public Light _light;
        public Volume _dangerVolume;
        public AnimationCurve _dangerAnimationCurve;
        //Character materials add here

        [Header("Options")]
        public AnimationCurve _healthLossCurve;
        public AnimationCurve _healthGainCurve; //Not used currently, we'll see 
        public Gradient _healthLossGradient;
        public Gradient _bodyGradient;
        [Header("LightOptions")]
        public float maxLightValue = 1f;
        public float minLightValue = 0.1f;
        public AnimationCurve lightOscillationAmplitudeCurve; //This is done according to sin(x) where x evolves by Time.deltaTime
        [Header("Duration & Mask")]
        public float maxHealthValue = 10f; //Max 10 seconds currently
        public LayerMask _safeMask;
        [SerializeField] private float _currentHealthValue;
        //[SerializeField] private Transform _originSpawnPoint;

        private float currentOscillationModifier;
        private float currentOscillationDuration;
        private float _originalLightRange;

        // Start is called before the first frame update
        void Awake()
        {
            InitializeValues();
        }

        private void InitializeValues()
        {
            if (m_OnCharacterDeath == null) m_OnCharacterDeath = new UnityEvent();
            safe = true;
            dead = false;
            _currentHealthValue = maxHealthValue;

            //Feedbacks
            _groundHealPS.Stop();
            _originalLightRange = _light.range;
        }

        // Update is called once per frame
        void Update()
        {
            CheckSafe();
        }

        private void LateUpdate()
        {
            UpdateAnimator();
            UpdateOscillation();
        }


        //If safe, top up health, else lower it by value
        /// <summary>
        /// Checksafe: checks if were on a landmark safespace, if we are then onSafeSpace true and thus we will not position a cadaver if we die, that'll be done pillar-side
        /// Also if on a landmark safespace, its the same as being safe so we get healing + we get particle effect
        /// </summary>
        private void CheckSafe()
        {
            safe = _proximityDetector.GetAttached();

            //Check if in safe space
            if (Physics.Raycast(t_checkLayerTransform.position, -Vector3.up, out _hit, Mathf.Infinity, _safeMask,QueryTriggerInteraction.Collide)) //Also report trigger hits?
            {
                onSafeSpace = true; 
                //Place particle system
                var particleTransform = _groundHealPS.transform;
                particleTransform.localPosition = particleTransform.InverseTransformPoint(_hit.point); //To get correct height
                particleTransform.localRotation.SetLookRotation(_hit.normal);
                if (!_groundHealPS.isPlaying) _groundHealPS.Play();
            }
            else
            {
                onSafeSpace = false;
                if (_groundHealPS.isPlaying) _groundHealPS.Stop();
            }

            if (!safe && onSafeSpace) safe = true; //If you're not near a body but still in a safe space, you're considered safe
            switch (safe)
            {
                case true: //Add life
                    _currentHealthValue += Time.deltaTime;
                    if (_currentHealthValue >= maxHealthValue) _currentHealthValue = maxHealthValue; //Clamp
                    break;
                case false: //Life loss
                    _currentHealthValue -= Time.deltaTime;
                    if (_currentHealthValue <= 0) _currentHealthValue = 0; //Clamp
                    
                    break;
            }
            var currentValue = (float)(_currentHealthValue / maxHealthValue);
            UpdateLifeVisuals(currentValue);
            if (_currentHealthValue == 0 && !dead)
            {
                KillPlayer();
                return;
            }
        }

        public void KillPlayer()
        {
            dead = true;
            _dangerVolume.weight = 0f;
            _playerInputs.DeactivateInput();
            _playerInputs.enabled = false;
            _characterController.enabled = false; //character controller has own definition of position, so we cant change position unless deactivated
            _thirdPersonController.enabled = false;
            _puppetMaster.Kill();

            PlayerDeathEvent.Invoke(safe, _thirdPersonController.transform.position);
            //Invoke("Resuscitate", 3f); //Temporary, normally this is done in game manager
        }

        public void Resuscitate()
        {
            dead = false;
            _puppetMaster.Resurrect();
            _currentHealthValue = maxHealthValue;
            _characterController.enabled = true;
            _thirdPersonController.enabled = true;
            _controllerAnimator.SetTrigger("KneelUp"); //RespawnAnim
            Invoke("GiveControlBack", 1.5f);
        }

        void GiveControlBack()
        {
            _playerInputs.enabled = true;
            _playerInputs.ActivateInput();
            
        }

        /// <summary>
        /// Updates materials and puppet muscles to reflect loss or regain of life
        /// Dont do it on hips to avoid sway of whole root, and clamp legs and feet to still have walking effect even when losing life
        /// </summary>
        private void UpdateLifeVisuals(float currentValue)
        {
            float legValue;
            if (safe || onSafeSpace) currentValue = _healthGainCurve.Evaluate(currentValue);
            else currentValue = _healthLossCurve.Evaluate(currentValue);
            legValue = currentValue <= 0.6f ? 0.6f : currentValue; //Clamp on legs
            _puppetMaster.SetMuscleWeights(Muscle.Group.Head, currentValue, currentValue);
            _puppetMaster.SetMuscleWeights(Muscle.Group.Arm, currentValue, currentValue);
            _puppetMaster.SetMuscleWeights(Muscle.Group.Hand, currentValue, currentValue);
            _puppetMaster.SetMuscleWeights(HumanBodyBones.Chest, currentValue, currentValue);
            _puppetMaster.SetMuscleWeights(Muscle.Group.Leg, legValue, legValue);
            //_puppetMaster.SetMuscleWeights(Muscle.Group.Foot, legValue, legValue);

            if (!allowColorChange) return;
            Color currentColor = _healthLossGradient.Evaluate(currentValue);
            //Lumiere
            _light.color = currentColor;
            _light.intensity = Mathf.Lerp(minLightValue, maxLightValue, currentValue);

            //Oscillation
            currentOscillationModifier = 0.5f + currentValue;

            //Organs
            UpdateOrganMaterial(currentColor, _bodyGradient.Evaluate(currentValue));
            //Post Processing
            _dangerVolume.weight = _dangerAnimationCurve.Evaluate(currentValue);
        }

        //Utility
        /*
        public void SetOriginSpawnPoint(Transform t)
        {
            _originSpawnPoint = t;
        }
        */

        private void UpdateAnimator()
        {
            var healthValue = _currentHealthValue / maxHealthValue;
            if (safe || onSafeSpace) healthValue = _healthGainCurve.Evaluate(healthValue);
            else healthValue = _healthLossCurve.Evaluate(healthValue);
            _controllerAnimator.SetFloat("Health", healthValue);
        }

        private void UpdateOscillation()
        {
            currentOscillationDuration += Time.deltaTime;
            if (currentOscillationDuration >= 3f) currentOscillationDuration = 0f;
            _light.range = (0.1f + lightOscillationAmplitudeCurve.Evaluate((currentOscillationDuration * currentOscillationModifier)/2f)) * _originalLightRange;
        }

        private void UpdateOrganMaterial(Color c, Color bodyColor)
        {
            var mat = _organsRenderer.materials[0];
            var mat2 = _bodyRenderer.material;
            mat.SetColor("_Main_Color_1", c);
            mat.SetColor("_SSS_Color", c);
            bodyColor.a = 221f/255f;
            mat2.SetColor("_BaseColor", bodyColor);
            _organsRenderer.materials[0] = mat;
        }

    }

   
}

