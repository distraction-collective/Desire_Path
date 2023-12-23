using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;
using Cinemachine;
using Unity.Mathematics;
using UnityEngine.Splines;
using UnityEngine.Events;

namespace DesirePaths.UX
{
    public class CameraBacktrack : MonoBehaviour
    {
        [Header("Backtrack cam")]

        [SerializeField] private float _backTrackDuration = 10f; //No matter how long the guts are, its always the same duration by lerp
        [SerializeField] private Transform _backTrackElement;
        [SerializeField] private CinemachineVirtualCamera _vcam;
        [SerializeField] private SplineContainer _spline;

        [Header("Rendering")]

        [SerializeField] private Camera _camera;
        [SerializeField] private Volume _mainPPVolume;
        [SerializeField] private VolumeProfile _backtrackPPProfile;
        [SerializeField] private VolumeProfile _defaultPPProfile;
        private UniversalAdditionalCameraData _camData;
        private float3 _backTrackPosition;
        private float3 _backTrackUp;
        private float3 _backTrackTangent;
        public UnityEvent OnBacktrackComplete;

        public void Backtrack(float d)
        {
            StartCoroutine(CameraBacktrackRoutine(d));
        }

        private IEnumerator CameraBacktrackRoutine(float delay)
        {
            var _camData = _camera.GetUniversalAdditionalCameraData();
            _camData.SetRenderer(2); // switch to renderer with render feature. while black screen fade
            _mainPPVolume.profile = _backtrackPPProfile;
            yield return new WaitForSeconds(delay);

            float _currentDuration = 0f;
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
            OnBacktrackComplete.Invoke();
        }
    }
}

