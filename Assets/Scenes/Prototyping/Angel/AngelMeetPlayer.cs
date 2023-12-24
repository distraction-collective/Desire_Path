using Cinemachine.Utility;
using UnityEngine;

public class AngelMeetPlayer : MonoBehaviour {
  public Transform player;
  public Animator animator;
  private Vector3 initialPosition;

  void Awake() { initialPosition = transform.position; }
  void Update() {
    float close = 5;
    float far = 50;
    float height = 10;

    float distance_on_ground = Vector3.Distance(
        transform.position.ProjectOntoPlane(new Vector3(0, 1, 0)),
        player.position.ProjectOntoPlane(new Vector3(0, 1, 0)));
    float factor = Mathf.InverseLerp(close, far, distance_on_ground);

    animator.SetLayerWeight(1, factor);
    transform.position = initialPosition + factor * new Vector3(0, height, 0);
    transform.LookAt(new Vector3(player.position.x, transform.position.y,
                                 player.position.z));
    transform.Rotate(new Vector3(-90, 0, 0));
  }
}
