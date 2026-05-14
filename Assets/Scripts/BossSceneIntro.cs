using UnityEngine;
using System.Collections;
public class BossSceneIntro : MonoBehaviour
{
    [SerializeField] CameraShake cameraShake;

    IEnumerator Start()
    {
        yield return new WaitForSeconds(0.1f);

        StartCoroutine(cameraShake.Shake(3f, 0.3f));
    }
}