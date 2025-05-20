Shader "Custom/SpecularLambertAmbient"
{
    Properties
    {
        _Color ("Base Color", Color) = (1,1,1,1)
        _AmbientColor ("Ambient Light", Color) = (0.2, 0.2, 0.2, 1)
        _SpecColor ("Specular Color", Color) = (1,1,1,1)
        _Shininess ("Shininess", Range(1, 100)) = 30
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
            };

            float4 _Color;
            float4 _AmbientColor;
            float4 _SpecColor;
            float _Shininess;

            // float3 _WorldSpaceCameraPos;

            v2f vert(appdata v)
            {
                v2f o;
                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.worldPos = worldPos.xyz;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);

                // Ambient
                float3 ambient = _AmbientColor.rgb;

                // Diffuse (Lambert)
                float diff = max(0, dot(normal, lightDir));
                float3 diffuse = _Color.rgb * diff;

                // Specular (Phong)
                float3 reflectDir = reflect(-lightDir, normal);
                float spec = pow(max(0, dot(viewDir, reflectDir)), _Shininess);
                float3 specular = _SpecColor.rgb * spec;

                float3 finalColor = ambient + diffuse + specular;
                return fixed4(finalColor, 1.0);
            }

            ENDCG
        }
    }
}
