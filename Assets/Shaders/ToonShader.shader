Shader "Custom/ToonShader"
{
    Properties
    {
        _Color ("Color Base", Color) = (1,1,1,1)
        _AmbientColor ("Luz Ambiental", Color) = (0.2,0.2,0.2,1)
        _Thresholds ("Umbrales de luz", Vector) = (0.95, 0.5, 0.2, 0)
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
            float4 _Thresholds;

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
                float shade = 0.0;

                if (NdotL > _Thresholds.x)
                    shade = 1.0;
                else if (NdotL > _Thresholds.y)
                    shade = 0.7;
                else if (NdotL > _Thresholds.z)
                    shade = 0.4;
                else
                    shade = 0.2;

                float3 toonColor = _Color.rgb * shade + _AmbientColor.rgb;

                return fixed4(toonColor, _Color.a);
            }

            ENDCG
        }
    }
}