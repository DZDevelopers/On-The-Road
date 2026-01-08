using UnityEngine;

public class AttackPoint : MonoBehaviour
{
    [SerializeField] private PlayerMovement _PM;
    private BoxCollider2D _BX2;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _BX2 = GetComponent<BoxCollider2D>();
    }

    // Update is called once per frame
    void Update()
    {
        if (_PM.facingDirection == Vector2.down)
        {
            _BX2.offset = new Vector2 (_BX2.offset.x,-0.45f);
            transform.rotation = Quaternion.Euler(transform.rotation.x, transform.rotation.y, 0);
        }
        if (_PM.facingDirection == Vector2.up)
        {
            _BX2.offset = new Vector2 (_BX2.offset.x,0.45f);
            transform.rotation = Quaternion.Euler(transform.rotation.x, transform.rotation.y, 0);
        }
        if (_PM.facingDirection == Vector2.right)
        {
            _BX2.offset = new Vector2 (_BX2.offset.x,0.45f);
            transform.rotation = Quaternion.Euler(transform.rotation.x, transform.rotation.y, 90);
        }
        if (_PM.facingDirection == Vector2.left)
        {
            _BX2.offset = new Vector2 (_BX2.offset.x,-0.45f);
            transform.rotation = Quaternion.Euler(transform.rotation.x, transform.rotation.y, 90);
        }
    }
}
