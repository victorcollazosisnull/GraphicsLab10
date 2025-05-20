Shader "Custom/FlagShader"
{
    Properties
    {
        _MainTex ("Bandera", 2D) = "white" {}
        _AmbientColor ("Luz Ambiental", Color) = (0.2, 0.2, 0.2, 1)
        _SpecColor ("Color Especular", Color) = (1, 1, 1, 1)
        _Shininess ("Brillo (Shininess)", Range(1, 100)) = 30
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            // No LightMode para evitar conflictos
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _AmbientColor;
            float4 _SpecColor;
            float _Shininess;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            v2f vert(appdata v)
            {
                v2f o;
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldPos = worldPos.xyz;
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz); // Luz direccional
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

                fixed4 texColor = tex2D(_MainTex, i.uv);

                // Luz ambiental
                float3 ambient = _AmbientColor.rgb;

                // Luz difusa (Lambert)
                float diff = max(0, dot(normal, lightDir));
                float3 diffuse = texColor.rgb * diff;

                // Luz especular (Phong)
                float3 reflectDir = reflect(-lightDir, normal);
                float spec = pow(max(0, dot(viewDir, reflectDir)), _Shininess);
                float3 specular = _SpecColor.rgb * spec;

                float3 finalColor = ambient + diffuse + specular;
                return fixed4(finalColor, texColor.a);
            }
            ENDCG
        }
    }
}
