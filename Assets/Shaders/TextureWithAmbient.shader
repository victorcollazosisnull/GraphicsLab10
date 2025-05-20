Shader "Custom/TextureWithAmbient"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _AmbientColor ("Ambient Light", Color) = (0.2, 0.2, 0.2, 1)
    }

    SubShader
    {
        Tags { "RenderType" = "Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _AmbientColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed3 finalColor = texColor.rgb + _AmbientColor.rgb;
                return fixed4(finalColor, texColor.a);
            }

            ENDCG
        }
    }
}
