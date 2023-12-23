using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Text;

namespace DesirePaths.Landmarks
{
    public class LandmarkManager : MonoBehaviour
    {
        /// <summary>
        /// Used to keep track if all the pillars have been activated
        /// </summary>
        private int _pillarCount = 0;
        private int _completedPillarsCount = 0;
        private int _landmarkCount = 0;
        private int _visitedLandmarksCount = 0;

        [SerializeField] private List<Landmark> _landmarks;
        public enum LandmarkEvents
        {
            PILLAR_ACTIVATION_START,
            PILLAR_ACTIVATED,
            LANDMARK_ENTERED,
            ALL_PILLARS_ACTIVATED,
            ALL_LANDMARKS_ENTERED
        }
        public LandmarkEvent OnLandmarkTriggered;
        public LandmarkEvent OnLandmarkCompletion;

        private bool _pillarsCompleted = false;
        [SerializeField] private string _playerTag = "Player_Collider"; // the collider used is under puppet master / pelvis
        private Landmark _lastLandmark;
        public Landmark GetLastLandmark => _lastLandmark;

        private void Awake()
        {
            _landmarks.ForEach(x =>
            {
                x.SetPlayerTag(_playerTag);
                if (x.GetType() == typeof(Pillar)) _pillarCount += 1;
                _landmarkCount += 1;
            });
            SubscribeToLandmarkTriggers(true);
        }

        private void OnDisable()
        {
            SubscribeToLandmarkTriggers(false);
        }

        void SubscribeToLandmarkTriggers(bool subscribe)
        {
            _landmarks.ForEach(x =>
            {
                if(subscribe)
                {
                    x.OnLandmarkTriggered.AddListener(delegate { LandmarkTriggered(x); });
                    x.OnLandmarkActivationStart.AddListener(delegate { LandmarkActivationStart(x); });
                } else
                {
                    x.OnLandmarkTriggered.RemoveAllListeners();
                    x.OnLandmarkActivationStart.RemoveAllListeners();
                }                
            });
        }

        void LandmarkTriggered(Landmark l)
        {
            _visitedLandmarksCount += 1;
            _lastLandmark = l;
            if (l.GetType() == typeof(Pillar))
            {
                if (_pillarsCompleted) return;
                OnLandmarkTriggered.Invoke(LandmarkEvents.PILLAR_ACTIVATED);
                _completedPillarsCount += 1;
                if (_completedPillarsCount == _pillarCount)
                {
                    _pillarsCompleted = true;
                    OnLandmarkCompletion.Invoke(LandmarkEvents.ALL_PILLARS_ACTIVATED);
                }
            } else {
                OnLandmarkTriggered.Invoke(LandmarkEvents.LANDMARK_ENTERED);                
            }
        }

        void LandmarkActivationStart(Landmark l)
        {
            if (!(l.GetType() == typeof(Pillar))) return;
            OnLandmarkTriggered.Invoke(LandmarkEvents.PILLAR_ACTIVATION_START);
        }

        private void OnGUI()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("Completed pillars : " + _completedPillarsCount + " / " + _pillarCount);
            sb.AppendLine("Visited landmarks : " + _visitedLandmarksCount + " / " + _landmarkCount);
            GUI.Box(new Rect(0, 0, 200, 100), sb.ToString());
        }
    }
}
