using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Splines;
using Unity.Mathematics;
using System;

public class GutsProximity : MonoBehaviour
{
    [Header("Collision detection")]
    public LayerMask _GutsLayerMask;
    public LayerMask _GroundLayerMask;
    public List<Vector3> _DroppedPoints = new List<Vector3>();
    [SerializeField] private float _TimeBetweenPointCapture = 3f; //Time between each time we check for dropped point
    private float _CurrentDropPointCooldown;
    [Header("Renderers")]

    public SplineContainer _connexionSpline;
    private Vector3 _closestPointAfterLastTouchedUpdate;
    public SplineExtrude _splineGeometry;
    public MeshRenderer _splineRenderer;
    public ParticleSystem hookedParticle;
    [Header("Detection Parameters")]
    public SplineContainer _splineContainer;
    public Spline _chosenSpline;
    public Transform playerTransform;
    public float detectRange = 2f;
    public int detectResolution = 5;
    public int detectIterations = 2;
    [SerializeField] private bool isAttached;
    private Vector3 worldSpaceNearestPoint;
    private float3 nearestPoint;
    private float nearestInterpolation;

    private RaycastHit _hit;

    // Start is called before the first frame update
    void Start()
    {

        isAttached = false;
        
    }

    /*private void OnTriggerEnter(Collider other)
    {
        var layer = other.gameObject.layer;
        if(_GutsLayerMask == (_GutsLayerMask | (1 << layer)))
        {
            _splineContainer = other.GetComponent<SplineContainer>();
        }
        
    }*/

    /*private void OnTriggerExit(Collider other)
    {
        if (_splineContainer == null) return;
        if(UnityEngine.Object.ReferenceEquals(_splineContainer.gameObject, other.gameObject))
        {
            //Update last touched point
            SplineUtility.GetNearestPoint<Spline>(_splineContainer.Spline, playerTransform.position, out nearestPoint, out nearestInterpolation);
            worldSpaceNearestPoint = (Vector3)nearestPoint;
            //_lastTouchedSplineContainer = null; //If we leave currently considered last found spline container - this is to avoid jittering between close splines once it starts getting crowded on map
        }
    }*/

    public Vector3 GetLastNearestPoint()
    {
        float3 candidatePoint = new float3();
        if (isAttached)
        {
            SplineUtility.GetNearestPoint<Spline>(_chosenSpline, playerTransform.position, out nearestPoint, out nearestInterpolation);
            candidatePoint = nearestPoint;
        }
        else candidatePoint = _closestPointAfterLastTouchedUpdate;
        return candidatePoint;
    }

    public bool GetSafe()
    {
        return isAttached;
    }

    // Update is called once per frame
    void Update()
    {
        DetectionTest();
        DetectPointIfNotConnected();
    }

    public bool GetAttached() { return isAttached; }


    private void LateUpdate()
    {
        PlaceOnPosition();
    }

    //Get nearest point on nearest spline to playerTransform, check if within distance
    //Find closest value
    private void DetectionTest()
    {
        if (_splineContainer == null) return;
        _chosenSpline = _splineContainer.Spline;
        float3 closestValue = Mathf.Infinity;
        float3 currentValue = 0f;
        float currentInterpolation = 0f;
        foreach (Spline spline in _splineContainer.Splines)
        {
            SplineUtility.GetNearestPoint<Spline>(spline, playerTransform.position, out currentValue, out currentInterpolation);
            if((Vector3.Distance(playerTransform.position, (Vector3)currentValue)) < (Vector3.Distance(playerTransform.position,(Vector3)closestValue)))
            {
                closestValue = currentValue;
                _chosenSpline = spline;
            }
        }
        //After this loop _chosenSpline is thus the closest spline because it has the closest getNearestPoint value
        //SplineUtility.GetNearestPoint<Spline>(_chosenSpline, playerTransform.position, out nearestPoint, out nearestInterpolation);
        worldSpaceNearestPoint = (Vector3)closestValue;
        var distanceToPlayer = Vector3.Distance(playerTransform.position, worldSpaceNearestPoint);
        bool oldAttached = isAttached;
        isAttached = distanceToPlayer <= detectRange ? true : false;
        if(!isAttached && oldAttached)
        {
            //If we just broke off connexion
            _closestPointAfterLastTouchedUpdate = (Vector3)worldSpaceNearestPoint;
        }
    }


    /// <summary>
    /// Drop points to make next spline if we die
    /// </summary>
    private void DetectPointIfNotConnected()
    {
        if (isAttached)
        {
            if (_DroppedPoints.Count != 0) ReinitializeDropPoints();
            return;
        } //No point in dropping if we are in range of a gut
        else if(_CurrentDropPointCooldown > 0)
        {
            _CurrentDropPointCooldown -= Time.deltaTime;
            return;
        }
        else
        {
            if (Physics.Raycast(transform.position, -Vector3.up, out _hit, Mathf.Infinity, _GroundLayerMask, QueryTriggerInteraction.Collide)) //Also report trigger hits?
            {
                _DroppedPoints.Add(_hit.point);
                //Debug.Log("dropping point at " + _hit.point);
            }
            _CurrentDropPointCooldown = _TimeBetweenPointCapture;
        }

    }

    public void ReinitializeDropPoints()
    {
        Debug.Log("clearing dropped points");
        _DroppedPoints.Clear();
        _CurrentDropPointCooldown = _TimeBetweenPointCapture;
    }

    private void PlaceOnPosition()
    {
        if (_splineContainer == null) return;
        if (isAttached)
        {
            var followerTransform = _splineContainer.transform.GetChild(0);
            followerTransform.position = worldSpaceNearestPoint;
            _connexionSpline.Spline.Clear();
            _splineRenderer.enabled = true;
            _connexionSpline.Spline.Add(new BezierKnot(_connexionSpline.transform.InverseTransformPoint(followerTransform.position)));
            
            var newTangent = CadaverGutsManager.Vector3ToFloat3(((playerTransform.position - followerTransform.position).normalized -   Vector3.up).normalized);
            var newTangent2 = CadaverGutsManager.Vector3ToFloat3(((playerTransform.position - followerTransform.position).normalized +   Vector3.up).normalized);
            _connexionSpline.Spline.Add(new BezierKnot(_connexionSpline.transform.InverseTransformPoint(playerTransform.position), newTangent, newTangent2));
            _connexionSpline.Spline.SetTangentModeNoNotify(0, TangentMode.AutoSmooth);
            _connexionSpline.Spline.SetTangentModeNoNotify(1, TangentMode.Mirrored);
            _splineGeometry.Rebuild();
            
#if UNITY_EDITOR
            Debug.DrawRay(playerTransform.position, worldSpaceNearestPoint - playerTransform.position, Color.green);
            //Debug.Log("nearestPoint: " + nearestPoint + " " + (worldSpaceNearestPoint - playerTransform.position).magnitude + " " + nearestInterpolation);
#endif
        }
        else
        {
            _splineRenderer.enabled = false;
#if UNITY_EDITOR
            Debug.DrawRay(playerTransform.position, worldSpaceNearestPoint - playerTransform.position, Color.red);
#endif
        }
    }
}
