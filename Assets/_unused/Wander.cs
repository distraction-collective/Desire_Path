using UnityEngine;
using System.Collections;

public class Wander: MonoBehaviour {
	public Vector3 targetPos;
	public bool isMoving = false;
	public float maxRange = 10f;
	public float waitTime = 3f;
	public float speed = 0.05f;
	
	void Update() {
		if(isMoving == false) {
			FindNewTargetPos();
		}
	}
	
	private void FindNewTargetPos() {
		Vector3 pos = transform.position;
		targetPos = new Vector3();
		targetPos.x  = Random.Range(pos.x - maxRange, pos.x + maxRange);
		targetPos.y = pos.y;
		targetPos.z = Random.Range(pos.z - maxRange, pos.z + maxRange);

		transform.LookAt(targetPos);
		StartCoroutine(Move());
	}
	
	IEnumerator Move() {
		isMoving = true;
		
		for (float t = 0.0f; t < 1.0f; t += Time.deltaTime * speed) {

			transform.position = Vector3.MoveTowards(transform.position, targetPos, t);
			yield return null;
		}
		
		yield return new WaitForSeconds(waitTime);
		isMoving = false;
		yield return null;
	}
	
	
	
}