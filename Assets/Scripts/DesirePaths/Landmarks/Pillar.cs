using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Playables;

namespace DesirePaths.Landmarks
{
    [RequireComponent(typeof(PlayableDirector))]
    public class Pillar : Landmark
    {
        [SerializeField] private Transform strandAnchor;
        [SerializeField] private PlayableDirector pillarCinematic => GetComponent<PlayableDirector>();

        public override void OnEnter()
        {
            PillarActivated();
        }

        void PillarActivated()
        {
            OnLandmarkActivationStart.Invoke();
            // listen to cinematic complete
            if(pillarCinematic.playableAsset == null)
            {
                PillarCinematic_played(pillarCinematic);
            } else
            {
                pillarCinematic.played += PillarCinematic_played;
                pillarCinematic.Play();
            }            
        }

        private void PillarCinematic_played(PlayableDirector obj)
        {
            OnLandmarkTriggered.Invoke();
        }

    }
}

