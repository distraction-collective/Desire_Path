using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ControllerMouse : MonoBehaviour
{

	public float moveSpeed = 6;

	Rigidbody myRigidbody;
	Camera viewCamera;
	Vector3 velocity;

	void Start () {
        
		myRigidbody = GetComponent<Rigidbody> ();
		viewCamera = Camera.main;
        
	}

	void Update () {
		Vector3 mousePos = viewCamera.ScreenToWorldPoint(new Vector3(Input.mousePosition.x, Input.mousePosition.y, viewCamera.transform.position.y));
		transform.LookAt (mousePos + Vector3.up * transform.position.y);
		velocity = new Vector3 (Input.GetAxisRaw ("Horizontal"), 0, Input.GetAxisRaw ("Vertical")).normalized * moveSpeed;
	}

	void FixedUpdate() {
		GetComponent<Rigidbody>().MovePosition (GetComponent<Rigidbody>().position + velocity * Time.fixedDeltaTime);
	}
}