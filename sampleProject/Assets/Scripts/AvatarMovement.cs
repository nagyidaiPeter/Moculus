﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MiceMovement : MonoBehaviour {

	// Use this for initialization
    private GramophoneDevice device;

    Rigidbody m_Rigidbody;

	void Start () {

		device = GramophoneDevice.Instance();
        m_Rigidbody = GetComponent<Rigidbody>();
	}
	
	// Update is called once per frame
	void Update () {

		m_Rigidbody.velocity = transform.forward * device.GetVelocity();

	}
}
