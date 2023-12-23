using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.Playables;

namespace DesirePaths.Landmarks
{
    [RequireComponent(typeof(BoxCollider))]
    public class Landmark : MonoBehaviour
    {        
        [HideInInspector] public UnityEvent OnLandmarkTriggered;
        [HideInInspector] public UnityEvent OnLandmarkActivationStart;

        private BoxCollider _collider => GetComponent<BoxCollider>();
        private string _playerTag = "Player_Collider";
        private bool _triggered = false;
        public void SetPlayerTag(string tag)
        {
            if (string.IsNullOrEmpty(tag)) return;
            _playerTag = tag;
        }

        private void Awake()
        {
            _collider.isTrigger = true;
        }

        #region COLLISIONS
        private void OnTriggerEnter(Collider col)
        {
            //Debug.Log("Something entered trigger");
            if (col.gameObject.CompareTag(_playerTag))
            {
                //Debug.Log("Player entered trigger");
                _collider.enabled = false;
                _triggered = true;
                OnEnter();
            }            
        }

        private void OnTriggerExit(Collider col)
        {
            if (col.gameObject.CompareTag(_playerTag))
            {
                OnExit();
            }
        }
        #endregion

        public virtual void OnEnter()
        {
            //Debug.Log("landmark entered - " + gameObject.name);
            OnTrigger();
        }

        public virtual void OnExit()
        {
            Debug.Log("landmark exited - " + gameObject.name);
        }

        public virtual void OnTrigger()
        {
            Debug.Log("landmark triggered - " + gameObject.name);
            OnLandmarkTriggered.Invoke();
        }

        private void OnDrawGizmos()
        {
            Gizmos.color = _triggered ? Color.green : (this.GetType() == typeof(Pillar) ? Color.red : Color.yellow);
            Gizmos.DrawCube(this.transform.position, new Vector3(_collider.size.x, _collider.size.y, _collider.size.z));
        }
    }
}
