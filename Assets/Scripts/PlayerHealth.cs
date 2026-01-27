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
    private BoxCollider2D boxCollider2D;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        boxCollider2D = GetComponent<BoxCollider2D>();
        playerHealth = playerMaxHealth;
    }

    // Update is called once per frame
    void Update()
    {
        playerInvincibility -= Time.deltaTime;
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