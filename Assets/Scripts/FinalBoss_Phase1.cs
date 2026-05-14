using System.Collections;
using System.Reflection;
using UnityEngine;
using UnityEngine.AI;
 
public class FinalBoss_Phase1 : MonoBehaviour
{
    [SerializeField] private int Health;
    [SerializeField] private Transform Player;
    [SerializeField] private GameObject PP;
    [SerializeField] private GameObject Shadow;
    private Animator anime;
    [SerializeField] private int bulletSpeed = 3;
    private float timer;
    private float shootCooldown = 0.5f;
    private int times = 0;
    private float TargetPX,TargetPY;
    public enum BossPhase1State
    {
        Idle,
        Shooting,
        Flying,
        SlamAttack,
        Dead
    }
    private float IO,SO,FO,SAO,DO;
    private float SOtimer = 0;
    public BossPhase1State currentState;
    public PlayerHealth playerHealth;
    private SpriteRenderer sr;
    private MaterialPropertyBlock mpb;

    void Start()
    {
        Health = 250;
        anime = GetComponent<Animator>();
        currentState = BossPhase1State.Idle;
        sr = GetComponent<SpriteRenderer>();
        mpb = new MaterialPropertyBlock();
    }
    void Update()
    {
        if (Health <= 0) 
        { 
            currentState = BossPhase1State.Dead; 
        }
        if (currentState == BossPhase1State.Idle)
        {
            if (IO < 1)
            {
                IO++;
                StartCoroutine(SS(3.1f));
            }
        }
        if (currentState == BossPhase1State.Shooting)
        {
            if (SO < 1)
            {
                SO = 1;
                StartCoroutine(ShootingPhase());
            }
        }
        if (currentState == BossPhase1State.Flying)
        {
            if (FO < 1)
            {
                FO = 1;
                anime.Play("FinalBoss_Phase_1_Jump");
                Shadow.SetActive(true);
                StartCoroutine(SAS(4f));
            }
            if (transform.position.y < 7)
            {
                transform.position += Vector3.up * 5 * Time.deltaTime;
                return;
            }
            Shadow.transform.position = Vector3.MoveTowards(Shadow.transform.position,new Vector3(Player.position.x, Player.position.y, Shadow.transform.position.z),8 * Time.deltaTime);
            transform.position = new Vector3(transform.position.x, Player.position.y+25, transform.position.z);
            anime.Play("FinalBoss_Phase_1_Idle");
            
        }
        if (currentState == BossPhase1State.SlamAttack)
        {
            if (SAO < 1)
            {
                TargetPX = Player.transform.position.x;
                TargetPY = Player.transform.position.y;
                SAO++;
                transform.position = new Vector3(TargetPX, TargetPY+25, transform.position.z);
            }
            if (transform.position.y >= TargetPY + 1.5)
            {
                Shadow.SetActive(false);
                transform.position += Vector3.down * 20f * Time.deltaTime;
            }
            else
            {
                if (DO < 1)
                {
                    DO = 1;
                    StartCoroutine(DS(2f));
                }
            }
        }   
        if (currentState == BossPhase1State.Dead)
        {
            
        }
        
    }
    void OnCollisionEnter2D(Collision2D collision)
    {
        if (collision.gameObject.tag == "Player")
        {
           playerHealth.TakeDamage(1);
        }
        if (collision.gameObject.tag == "Bullet")
        {
            Destroy(collision.gameObject);
            Damage(10);
        }
    }
    void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.gameObject.tag == "AttackPoint")
        {
            Damage(5);
        }
    }
    void Shoot()
    {
        GameObject B = Instantiate(PP,new Vector3 (transform.position.x,transform.position.y+1,-7),Quaternion.identity);
        Vector2 direction = (Player.transform.position - B.transform.position).normalized;
        B.GetComponent<Rigidbody2D>().linearVelocity = direction * bulletSpeed;
        Physics2D.IgnoreCollision(B.GetComponent<Collider2D>(),GetComponent<Collider2D>());
    }
    void Damage(int amount)
    {
        StartCoroutine(FlashWhite());
        Health -= amount;
        if (Health <= 0)
        {
            EDeath();
        }
    }
    void EDeath()
    {
        anime.Play("FinalBoss_Phase_1_Death");
    }
    IEnumerator FlashWhite()
    {
        sr.GetPropertyBlock(mpb);
        mpb.SetFloat("_FlashAmount", 1f);
        sr.SetPropertyBlock(mpb);

        yield return new WaitForSeconds(0.1f);

        sr.GetPropertyBlock(mpb);
        mpb.SetFloat("_FlashAmount", 0f);
        sr.SetPropertyBlock(mpb);
    }
    IEnumerator IS(float delay) 
    {
        yield return new WaitForSeconds(delay);

    }
    IEnumerator SS(float delay) 
    {
        anime.Play("FinalBoss_Phase_1_Idle");

        yield return new WaitForSeconds(delay);

        currentState = BossPhase1State.Shooting;
    }
    IEnumerator FS(float delay) 
    {
        yield return new WaitForSeconds(delay);
        
    }
    IEnumerator SAS(float delay) 
    {
        yield return new WaitForSeconds(delay);
        currentState = BossPhase1State.SlamAttack;
    }
    IEnumerator DS(float delay) 
    {
        yield return new WaitForSeconds(delay);
        IO = 0; FO = 0; SAO = 0; DO = 0;
        currentState = BossPhase1State.Idle;
    }
    
    IEnumerator ShootingPhase()
    {
        anime.Play("FinalBoss_Phase_1_Between");
        yield return new WaitForSeconds(0.5f);
        anime.Play("FinalBoss_Phase_1_Charge");
        yield return new WaitForSeconds(2f);

        float shootTime = 4f;
        float t = 0f;

        while (t < shootTime)
        {
            Shoot();
            yield return new WaitForSeconds(shootCooldown);
            t += shootCooldown;
        }

        times = 0;
        SO = 0;

        currentState = BossPhase1State.Flying;

    }
}