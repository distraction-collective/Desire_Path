using System.Collections;
using System.Collections.Generic;
using MonsterLove.Collections;
using UnityEngine;
using UnityEngine.Splines;
using Unity.Mathematics;
using System.Linq;

public class CadaverGutsManager : MonoBehaviour
{
    [Header("Player Info")]
    public Transform _gutsOrigin;
    //public Transform playerTransform;
    [Header("Cadavers and splines")]
    public List<GameObject> currentCadaverArray = new List<GameObject>();
    public SplineContainer _splineContainer;
    
    public SplineExtrude _splineGeometry; //We arent rebuilding a spline, so much as adding splines on top of the ones we already have
    [SerializeField] private GutsProximity _GutsDetector;
    [Header("Data")]
    [SerializeField] private GameObject _gutsPrefab;
    [SerializeField] private PoolManager cadaverPool;
    [SerializeField] private PoolManager gutsPool; //We need a prefab because we have both a spline and spline extrude on it for geometry!
    [SerializeField] private CadaverData _data;

    //Raycasts
    RaycastHit _hit;

    /// <summary>
    /// TODO:
    /// One Spline Container generates multiple splines (_SplineContainer.Splines)
    /// Player connects to a spline with a detection test iterating through all the splines, we keep track of the last spline we were On (still referenced when we leave it) - check GutsProximity.cs
    /// When we leave it we index closest point from spline container's spline we were at - thats our initial point for the next spline we generate, so that they connect
    /// Last point is cadaver position in local space of spline
    /// , if number of splines generated is 0. Then we take _gutsOrigin as the starting point of the next spline.
    /// When we leave a guts path, index a new point every _timeBetweenPoints to list _droppedPoints as long as we are not attached
    /// On connexion with a spline in guts proximity we call ReinitializePoints() because we are safe again or onSafeSpace. 
    /// </summary>

    
    
    // Start is called before the first frame update
    void Start()
    {
        InitializePool();
        InitializeOriginKnot();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    //Useful to get last spline for backtrack (playerSpawner.cs)
    public Spline GetLastCreatedSpline()
    {
        int lastIndex = _splineContainer.Splines.Count - 1;
        return _splineContainer.Splines[lastIndex];
    }


    //Getters
    public int GetNumberOfCadavers()
    {
        return currentCadaverArray.Count;
    }

    public void DepositCadaverOnPosition(Vector3 playerPosition, List<Vector3> droppedPoints)
    {
        StartCoroutine(DepositCadaverCoroutine(playerPosition, droppedPoints));
    }
    /// <summary>
    /// Deposits cadaver at playerTransform Position, using a raycast above player and pointing downwards,
    /// we get the exact position and normal offset where we should put the body
    /// </summary>

    public IEnumerator DepositCadaverCoroutine(Vector3 playerPosition, List<Vector3> droppedPoints)
    {
        yield return new WaitForSeconds(1.5f);

        GameObject newCadaver;
        Debug.Log("depositing new cadaver");
        int randPrefabIndex = UnityEngine.Random.Range(0, _data.randomCadaverPrefabs.Length); //Lets choose a random prefab
        if (Physics.Raycast(playerPosition + Vector3.up * _data.basicDetectionHeightDifferential, -Vector3.up, out _hit, Mathf.Infinity, _data.layerToPutCadaver)){
            var randPrefab = _data.randomCadaverPrefabs[randPrefabIndex];
            newCadaver = cadaverPool.spawnObject(randPrefab, _hit.point, Quaternion.identity);
            currentCadaverArray.Add(newCadaver);
            newCadaver.transform.rotation = Quaternion.FromToRotation(transform.up, _hit.normal) * newCadaver.transform.rotation;
        }
        else //We failed to hit, proceed to just put it where playerTransform is - itll be ugly but it still works
        {
            var randPrefab = _data.randomCadaverPrefabs[randPrefabIndex];
            newCadaver = cadaverPool.spawnObject(randPrefab, playerPosition + Vector3.up * _data.cadaverDepositExtraHeight, Quaternion.identity);
            currentCadaverArray.Add(newCadaver);
        }
        ConnectSplineToNewCadaver(newCadaver.transform, _hit.point, _hit.normal, droppedPoints);
    }

    public void ConnectSplineToNewCadaver(Transform newCadaverTransform, Vector3 hitpoint, Vector3 hitnormal, List<Vector3> droppedPoints)
    {
        //Make sure previous knot goes in direction of final knot and set tangent mode to Auto Smooth

        Vector3 DistanceBetweenTwoCadavers;
        Vector3 lastCadaverPosition;
        float numberofCadavers = GetNumberOfCadavers();
        if (numberofCadavers > 1)
        {
            lastCadaverPosition = currentCadaverArray[currentCadaverArray.Count - 2].transform.position;
        }
        else lastCadaverPosition = _gutsOrigin.position;
        DistanceBetweenTwoCadavers = hitpoint - lastCadaverPosition;
        //lastCurve.Tangent1 = Vector3ToFloat3(DistanceBetweenTwoCadavers.normalized);
        //_splineContainer.Spline.SetTangentModeNoNotify(lastCurveIndex, TangentMode.AutoSmooth);

        //Add intermediate knots from dropped points, then place them with raycast with sin function to add variation
        int IntermediateNumberOfKnots = droppedPoints.Count;
        int totalNumberOfKnots = IntermediateNumberOfKnots + 2; //We add two more: First point is nearestpoint/guts origin, last point is Cadaver position
        Vector3 iterativePosition;
        Vector3 positionToPut;
        

        //Add new spline container and geometry
        //var newSpline = gutsPool.spawnObject(_gutsPrefab).GetComponent<SplineContainer>();
        //newSpline.gameObject.SetActive(true);
        //_splineContainer.Add(newSpline);
        
        int indexOfNewSpline = _splineContainer.Splines.Count; //Since we add a spline, this checks out (N + 1)
        var newSpline = _splineContainer.AddSpline();
        _splineContainer.Splines[indexOfNewSpline].SetTangentMode(TangentMode.AutoSmooth);
        //_splineGeometry.Add(newSpline.GetComponent<SplineExtrude>());
        
        Vector3 pointConnectedToLastSpline = Vector3.zero;
        //Put first point on last spline touched or guts origin if first spline to be generated 
        var knots = new BezierKnot[totalNumberOfKnots];
        if (indexOfNewSpline <= 1)
        {
            pointConnectedToLastSpline = _gutsOrigin.position;
        }
        else
        {
            pointConnectedToLastSpline = _GutsDetector.GetLastNearestPoint();
        }
        Physics.Raycast(pointConnectedToLastSpline + Vector3.up * _data.basicDetectionHeightDifferential, -Vector3.up, out _hit, Mathf.Infinity, _data.layerToPutCadaver);
        positionToPut = _hit.point + Vector3.up * _data.cadaverDepositExtraHeight;
        positionToPut += Vector3.Cross(DistanceBetweenTwoCadavers, Vector3.up).normalized * _data.intermediateKnotSinAmplitude * Mathf.Sin(Time.time); //Add sin amplitude to left side, adds a bit of variation!

        knots[0] = new BezierKnot(_splineContainer.transform.InverseTransformPoint(positionToPut));
        _splineContainer.Splines[indexOfNewSpline].SetTangentMode(TangentMode.AutoSmooth);

#if UNITY_EDITOR
        Debug.Log("Spline index is " + _splineContainer.Splines.Count);
        Debug.Log("Dropped points amount is " + droppedPoints.Count);
#endif

        //Do it for the rest
        
        for (int i=1; i < IntermediateNumberOfKnots + 1; i++)
        {
            //Placement along distance
            iterativePosition = droppedPoints[i-1];
        
            Physics.Raycast(iterativePosition + Vector3.up * _data.basicDetectionHeightDifferential, -Vector3.up, out _hit, Mathf.Infinity, _data.layerToPutCadaver);
            positionToPut = _hit.point + Vector3.up * _data.cadaverDepositExtraHeight;
            positionToPut += Vector3.Cross(DistanceBetweenTwoCadavers, Vector3.up).normalized * _data.intermediateKnotSinAmplitude * Mathf.Sin(Time.time); //Add sin amplitude to left side

            //_splineContainer[indexOfNewSpline].Spline.Add(new BezierKnot(_splineContainer[indexOfNewSpline].transform.InverseTransformPoint(positionToPut)));           
            knots[i] = new BezierKnot(_splineContainer.transform.InverseTransformPoint(positionToPut)); //Inverse transform point because splines are rendered in local space        

#if UNITY_EDITOR
            Debug.DrawRay(iterativePosition + Vector3.up * _data.basicDetectionHeightDifferential, -Vector3.up * 10f, Color.magenta);
            Debug.Log("putting knot " + i.ToString() + " at position " + iterativePosition);
#endif


        }
        //Add ending knot and make sure that in Tangent corresponds to the normal 
        Unity.Mathematics.float3 endTangent = Vector3ToFloat3(hitnormal * _data.autoBezierCurveAmplitude);
        knots[totalNumberOfKnots-1] = new BezierKnot(_splineContainer.transform.InverseTransformPoint(newCadaverTransform.position + Vector3.up * _data.cadaverDepositExtraHeight), endTangent, endTangent);

        //_splineContainer[indexOfNewSpline].Spline.SetTangentModeNoNotify(_splineContainer[indexOfNewSpline].Spline.Count - 1, TangentMode.AutoSmooth);
        newSpline.Knots = knots;
        _splineContainer.Splines[indexOfNewSpline].SetTangentMode(TangentMode.AutoSmooth);
        _splineGeometry.Rebuild(); //Rebuild geometry to accomodate new spline knots 
    }

    /// <summary>
    /// Knots take tangent arguments as float3, faster compiling
    /// </summary>
    /// <param name="v"></param>
    /// <returns></returns>
    public static Unity.Mathematics.float3 Vector3ToFloat3(Vector3 v)
    {
        Unity.Mathematics.float3 tan = new float3();
        tan.x = v.x;
        tan.y = v.y;
        tan.z = v.y;
        return tan;
    }

    public static Vector3 Float3ToVector3(float3 f)
    {
        Vector3 v = new Vector3();
        v.x = f.x;
        v.y = f.y;
        v.y = f.z;
        return v;
    }

    public void InitializeOriginKnot()
    {
        _splineContainer.Spline.Add(new BezierKnot(_splineContainer.transform.InverseTransformPoint(_gutsOrigin.position + Vector3.up * _data.cadaverDepositExtraHeight)));
        _splineContainer.Spline.SetTangentMode(TangentMode.AutoSmooth);
        _splineGeometry.Rebuild(); //Rebuild geometry to accomodate new spline knot
    }

    void InitializePool()
    {
        foreach (var cadaverPrefab in _data.randomCadaverPrefabs)
        {
            cadaverPool.warmPool(cadaverPrefab, _data.maxPopPerPrefab);
        }
    }
}
