using System;
using Unity.VectorGraphics;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.SceneManagement;

public class PlayerHealth : MonoBehaviour
{
    public int playerMaxHealth = 6;
    public int playerHealth = 6;
    [SerializeField] float playerInvincibility = 1f;
    private SpriteRenderer SR;
    private BoxCollider2D boxCollider2D;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        boxCollider2D = GetComponent<BoxCollider2D>();
        SR = GetComponent<SpriteRenderer>();
        playerHealth = playerMaxHealth;
    }

    // Update is called once per frame
    void Update()
    {
        playerInvincibility -= Time.deltaTime;
        if (playerHealth > playerMaxHealth)
        {
            playerHealth = playerMaxHealth;
        }
        if (playerInvincibility > 0)
        {
            float alpha = Mathf.Lerp(0.5f, 0.95f, Mathf.PingPong(Time.time * 5f, 1f));
            Color c = SR.color;
            c.a = alpha;
            SR.color = c;
        }
        else
        {
            Color c = SR.color;
            c.a = 1f;
            SR.color = c;
        }
    }
    public void TakeDamage(int damage)
    {
        if (playerInvincibility > 0)
        {
            return;
        }
        if (playerInvincibility <= 0)
        {
            playerHealth = playerHealth - damage;
            playerInvincibility = 1f;
            Death();
        }
    }
    void Death()
    {
        if (playerHealth <= 0)
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        }
    }

}