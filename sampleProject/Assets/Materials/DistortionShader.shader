Shader "Custom/DistortionShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_RedK1("RedK1", Float) = 0
		_RedK2("RedK2", Float) = 0
		_RedK3("RedK3", Float) = 0

		_GreenK1("GreenK1", Float) = 0
		_GreenK2("GreenK2", Float) = 0
		_GreenK3("GreenK3", Float) = 0

		_BlueK1("BlueK1", Float) = 0
		_BlueK2("BlueK2", Float) = 0
		_BlueK3("BlueK3", Float) = 0

		_P1("P1", Float) = 0
		_P2("P2", Float) = 0
	}
		SubShader
		{
			// No culling or depth  
			Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				#pragma vertex vert  
				#pragma fragment frag  

				#include "UnityCG.cginc"  

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				sampler2D _MainTex;

				fixed _RedK1;
				fixed _RedK2;
				fixed _RedK3;

				fixed _GreenK1;
				fixed _GreenK2;
				fixed _GreenK3;

				fixed _BlueK1;
				fixed _BlueK2;
				fixed _BlueK3;

				fixed _P1;
				fixed _P2;

				fixed4 frag(v2f i) : SV_Target
				{
					fixed2 r = i.uv - 0.5;

					fixed r2 = pow(r.x, 2) + pow(r.y, 2);
					fixed r4 = pow(r2, 2);
					fixed r6 = pow(r2, 3);


					fixed redRadDistort = 1 + (_RedK1 * r2) + (_RedK2 * r4) + (_RedK3 * r6);
					fixed redTanDistort = 0;
					fixed redDistort = redRadDistort + redTanDistort;

					fixed greenRadDistort = 1 + (_GreenK1 * r2) + (_GreenK2 * r4) + (_GreenK3 * r6);
					fixed greenTanDistort = 0;
					fixed greenDistort = greenRadDistort + greenTanDistort;

					fixed blueRadDistort = 1 + (_BlueK1 * r2) + (_BlueK2 * r4) + (_BlueK3 * r6);
					fixed blueTanDistort = 0;
					fixed blueDistort = blueRadDistort + blueTanDistort;

					fixed2 redUv = redDistort * (i.uv - 0.5) + 0.5;
					fixed2 greenUv = greenDistort * (i.uv - 0.5) + 0.5;
					fixed2 blueUv = blueDistort * (i.uv - 0.5) + 0.5;

					fixed4 redColor = tex2D(_MainTex, redUv);
					fixed4 greenColor = tex2D(_MainTex, greenUv);
					fixed4 blueColor = tex2D(_MainTex, blueUv);

					fixed4 color = fixed4(0, 0, 0, 0);

					if (((redUv.x > 0) && (redUv.x < 1) || (redUv.y > 0) && (redUv.y < 1)))
					{
						color = fixed4(redColor.x, greenColor.y, blueColor.z, 1.0);
					}
					else
					{
						color = fixed4(0, 0, 0, 0);
					}

					return color;
				}
				ENDCG
			}
		}
}