Shader "Custom/ToonShader"
{
    Properties
    {
        _Color ("Color Base", Color) = (1,1,1,1)
        _AmbientColor ("Luz Ambiental", Color) = (0.2,0.2,0.2,1)
        _ToonLevels ("Niveles de Sombra", Range(1,5)) = 3
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

            float4 _Color;
            float4 _AmbientColor;
            float _ToonLevels;

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

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(UnityObjectToWorldNormal(v.normal));
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float3 normal = normalize(i.worldNormal);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);

                float NdotL = max(0, dot(normal, lightDir));

                // Toon shading escalonado
                float shade = floor(NdotL * _ToonLevels) / (_ToonLevels - 1);

                float3 toonColor = _Color.rgb * shade + _AmbientColor.rgb;

                return fixed4(toonColor, _Color.a);
            }

            ENDCG
        }
    }
}
