Shader "Custom/LambertWithAmbient"
{
    Properties
    {
        _Color ("Base Color", Color) = (1,1,1,1)
        _AmbientColor ("Ambient Light", Color) = (0.2, 0.2, 0.2, 1)
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
            };

            float4 _Color;
            float4 _AmbientColor;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float NdotL = max(0, dot(normal, lightDir));
                float3 diffuse = _Color.rgb * NdotL;
                float3 ambient = _AmbientColor.rgb;

                return fixed4(diffuse + ambient, 1.0);
            }
            ENDCG
        }
    }
}