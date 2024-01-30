using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using RootMotion.Dynamics;
using UnityEngine.Events;
using UnityEngine.Splines;
using Unity.Mathematics;
using Cinemachine;
using UnityEngine.Rendering.Universal;
using UnityEngine.Rendering;
using UnityEngine.Rendering.HighDefinition;

namespace DesirePaths
{
    public class PlayerSpawner : MonoBehaviour
    {
        [SerializeField] private Transform _originSpawnPoint;
        [SerializeField] PuppetMaster _puppetMaster;
        [SerializeField] private float _respawnDelay = 3f;

        [Header("Backtrack cam")]

        [SerializeField] private float _backTrackDuration = 10f; //No matter how long the guts are, its always the same duration by lerp
        [SerializeField] private Transform _backTrackElement;
        [SerializeField] private CinemachineVirtualCamera _vcam;
        [SerializeField] private Spline _spline;


        private float3 _backTrackPosition;
        private float3 _backTrackUp;
        private float3 _backTrackTangent;
        private StarterAssets.ThirdPersonController _thirdPersonController;

        [Header("Rendering")]

        [SerializeField] private Camera _camera;
        [SerializeField] private Volume _mainPPVolume;
        [SerializeField] private VolumeProfile _backtrackPPProfile;
        [SerializeField] private VolumeProfile _defaultPPProfile;
        private UniversalAdditionalCameraData _camData;

        public StarterAssets.ThirdPersonController SetThirdPersonController
        {
            set
            {
                _thirdPersonController = value;
            }
        }
        public UnityEvent OnPlayerRespawnComplete = new UnityEvent();

        public void RespawnPlayer()
        {
            if (_thirdPersonController == null) return;
            StartCoroutine(RespawnRoutine());
        }

        private IEnumerator RespawnRoutine()
        {
            yield return new WaitForSeconds(_respawnDelay / 2); //Before we start backtrack
            var _camData = _camera.GetUniversalAdditionalCameraData(); 
            _camData.SetRenderer(2); // switch to renderer with render feature. while black screen fade
            _mainPPVolume.profile = _backtrackPPProfile;
            yield return new WaitForSeconds(_respawnDelay/2);

            float _currentDuration = 0f;
            _spline = GameManager._instance.GetLastGuts();
            _spline.Evaluate(1, out _backTrackPosition, out _backTrackTangent, out _backTrackUp); //Reposition for first frame
            _backTrackElement.position = (Vector3)_backTrackPosition;
            _backTrackElement.rotation = Quaternion.LookRotation(-(Vector3)_backTrackTangent, (Vector3)_backTrackUp);

            _backTrackElement.gameObject.SetActive(true);
            _vcam.enabled = true;
            
            
            while (_currentDuration < _backTrackDuration)
            {
                _spline.Evaluate(Mathf.Lerp(1, 0, _currentDuration / _backTrackDuration), out _backTrackPosition, out _backTrackTangent, out _backTrackUp);

                _backTrackElement.position = (Vector3)_backTrackPosition;
                _backTrackElement.rotation = Quaternion.LookRotation(-(Vector3)_backTrackTangent, (Vector3)_backTrackUp);
                _currentDuration += Time.deltaTime;
                yield return null;
            }
            _camData.SetRenderer(0);
            _mainPPVolume.profile = _defaultPPProfile;
            _vcam.enabled = false;
            _backTrackElement.gameObject.SetActive(false);
           

            //Respawn
            _thirdPersonController.transform.position = _originSpawnPoint.transform.position;
            _puppetMaster.Teleport(_originSpawnPoint.transform.position, Quaternion.identity, true);
            if(OnPlayerRespawnComplete != null) OnPlayerRespawnComplete.Invoke();
        }
    }
}

