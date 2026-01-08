using UnityEngine;
using UnityEngine.UI;

public class CanavsHealth : MonoBehaviour
{
    public PlayerHealth _PH;
    [SerializeField] private Image Health_1;
    [SerializeField] private Image Health_2;
    [SerializeField] private Image Health_3;
    [SerializeField] private Sprite FullHealth;
    [SerializeField] private Sprite HalfHealth;
    [SerializeField] private Sprite NoHealth;

    void Update()
    {
        if (_PH.playerHealth == 6)
        {
            Health_3.sprite = FullHealth;
            Health_2.sprite = FullHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 5)
        {
            Health_3.sprite = HalfHealth;
            Health_2.sprite = FullHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 4)
        {
            Health_3.sprite = NoHealth;
            Health_2.sprite = FullHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 3)
        {
            Health_3.sprite = NoHealth;
            Health_2.sprite = HalfHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 2)
        {
            Health_3.sprite = NoHealth;
            Health_2.sprite = NoHealth;
            Health_1.sprite = FullHealth;
        }
        if (_PH.playerHealth == 1)
        {
            Health_3.sprite = NoHealth;
            Health_2.sprite = NoHealth;
            Health_1.sprite = HalfHealth;
        }
    }
}
