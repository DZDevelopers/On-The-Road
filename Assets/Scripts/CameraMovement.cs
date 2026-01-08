using UnityEngine;
using UnityEngine.UIElements;

public class CameraMovement : MonoBehaviour
{
    public GameObject Player;
    
    void LateUpdate()
    {
        transform.position = new Vector3 (Player.transform.position.x,Player.transform.position.y,transform.position.z);
    }
}
