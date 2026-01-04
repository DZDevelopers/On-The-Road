//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-GUIRoundedRect" {
Properties {
_MainTex ("Texture", any) = "white" { }
_SrcBlend ("SrcBlend", Float) = 5
_DstBlend ("DstBlend", Float) = 10
}
SubShader {
 Pass {
  Blend Zero Zero, One OneMinusSrcAlpha
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 44824
Program "vp" {
SubProgram "gles " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 unity_GUIClipTextureMatrix;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 1.0);
  tmpvar_4.xy = (unity_MatrixV * (unity_ObjectToWorld * tmpvar_2)).xy;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (unity_GUIClipTextureMatrix * tmpvar_4).xy;
  xlv_TEXCOORD2 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_OES_standard_derivatives : enable
uniform sampler2D _MainTex;
uniform sampler2D _GUIClipTexture;
uniform bool _ManualTex2SRGB;
uniform highp int _SrcBlend;
uniform highp float _CornerRadiuses[4];
uniform highp float _BorderWidths[4];
uniform highp float _Rect[4];
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  highp float clipAlpha_2;
  highp float borderAlpha_3;
  highp float cornerAlpha_4;
  highp vec2 center_5;
  highp int radiusIndex_6;
  highp float bw2_7;
  highp float bw1_8;
  mediump vec4 col_9;
  highp float tmpvar_10;
  tmpvar_10 = (1.0/(abs(dFdx(xlv_TEXCOORD2.x))));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  col_9 = tmpvar_11;
  if (_ManualTex2SRGB) {
    col_9.xyz = max (((1.055 * 
      pow (max (col_9.xyz, vec3(0.0, 0.0, 0.0)), vec3(0.4166667, 0.4166667, 0.4166667))
    ) - 0.055), vec3(0.0, 0.0, 0.0));
  };
  col_9 = (col_9 * xlv_COLOR);
  bool tmpvar_12;
  tmpvar_12 = (((xlv_TEXCOORD2.x - _Rect[0]) - (_Rect[2] / 2.0)) <= 0.0);
  bool tmpvar_13;
  tmpvar_13 = (((xlv_TEXCOORD2.y - _Rect[1]) - (_Rect[3] / 2.0)) <= 0.0);
  bw1_8 = _BorderWidths[0];
  bw2_7 = _BorderWidths[1];
  radiusIndex_6 = 0;
  if (tmpvar_12) {
    highp int tmpvar_14;
    if (tmpvar_13) {
      tmpvar_14 = 0;
    } else {
      tmpvar_14 = 3;
    };
    radiusIndex_6 = tmpvar_14;
  } else {
    highp int tmpvar_15;
    if (tmpvar_13) {
      tmpvar_15 = 1;
    } else {
      tmpvar_15 = 2;
    };
    radiusIndex_6 = tmpvar_15;
  };
  highp float tmpvar_16;
  tmpvar_16 = _CornerRadiuses[radiusIndex_6];
  highp vec2 tmpvar_17;
  tmpvar_17.x = (_Rect[0] + tmpvar_16);
  tmpvar_17.y = (_Rect[1] + tmpvar_16);
  center_5 = tmpvar_17;
  if (!(tmpvar_12)) {
    center_5.x = ((_Rect[0] + _Rect[2]) - tmpvar_16);
    bw1_8 = _BorderWidths[2];
  };
  if (!(tmpvar_13)) {
    center_5.y = ((_Rect[1] + _Rect[3]) - tmpvar_16);
    bw2_7 = _BorderWidths[3];
  };
  bool tmpvar_18;
  if (tmpvar_12) {
    tmpvar_18 = (xlv_TEXCOORD2.x <= center_5.x);
  } else {
    tmpvar_18 = (xlv_TEXCOORD2.x >= center_5.x);
  };
  bool tmpvar_19;
  if (tmpvar_18) {
    bool tmpvar_20;
    if (tmpvar_13) {
      tmpvar_20 = (xlv_TEXCOORD2.y <= center_5.y);
    } else {
      tmpvar_20 = (xlv_TEXCOORD2.y >= center_5.y);
    };
    tmpvar_19 = tmpvar_20;
  } else {
    tmpvar_19 = bool(0);
  };
  mediump float tmpvar_21;
  if (tmpvar_19) {
    mediump float rawDist_22;
    highp vec2 v_23;
    bool tmpvar_24;
    tmpvar_24 = ((bw1_8 > 0.0) || (bw2_7 > 0.0));
    highp vec2 tmpvar_25;
    tmpvar_25 = (xlv_TEXCOORD2.xy - center_5);
    v_23 = tmpvar_25;
    highp float tmpvar_26;
    tmpvar_26 = ((sqrt(
      dot (tmpvar_25, tmpvar_25)
    ) - tmpvar_16) * tmpvar_10);
    mediump float tmpvar_27;
    if (tmpvar_24) {
      highp float tmpvar_28;
      tmpvar_28 = clamp ((0.5 + tmpvar_26), 0.0, 1.0);
      tmpvar_27 = tmpvar_28;
    } else {
      tmpvar_27 = 0.0;
    };
    highp float tmpvar_29;
    tmpvar_29 = (tmpvar_16 - bw1_8);
    highp float tmpvar_30;
    tmpvar_30 = (tmpvar_16 - bw2_7);
    v_23.y = (tmpvar_25.y * (tmpvar_29 / tmpvar_30));
    highp float tmpvar_31;
    tmpvar_31 = ((sqrt(
      dot (v_23, v_23)
    ) - tmpvar_29) * tmpvar_10);
    rawDist_22 = tmpvar_31;
    mediump float tmpvar_32;
    tmpvar_32 = clamp ((rawDist_22 + 0.5), 0.0, 1.0);
    mediump float tmpvar_33;
    if (tmpvar_24) {
      mediump float tmpvar_34;
      if (((tmpvar_29 > 0.0) && (tmpvar_30 > 0.0))) {
        tmpvar_34 = tmpvar_32;
      } else {
        tmpvar_34 = 1.0;
      };
      tmpvar_33 = tmpvar_34;
    } else {
      tmpvar_33 = 0.0;
    };
    mediump float tmpvar_35;
    if ((tmpvar_27 == 0.0)) {
      tmpvar_35 = tmpvar_33;
    } else {
      tmpvar_35 = (1.0 - tmpvar_27);
    };
    tmpvar_21 = tmpvar_35;
  } else {
    tmpvar_21 = 1.0;
  };
  cornerAlpha_4 = tmpvar_21;
  col_9.w = (col_9.w * cornerAlpha_4);
  highp vec4 tmpvar_36;
  tmpvar_36.x = (_Rect[0] + _BorderWidths[0]);
  tmpvar_36.y = (_Rect[1] + _BorderWidths[1]);
  tmpvar_36.z = (_Rect[2] - (_BorderWidths[0] + _BorderWidths[2]));
  tmpvar_36.w = (_Rect[3] - (_BorderWidths[1] + _BorderWidths[3]));
  bool tmpvar_37;
  tmpvar_37 = (((
    (xlv_TEXCOORD2.x >= tmpvar_36.x)
   && 
    (xlv_TEXCOORD2.x <= (tmpvar_36.x + tmpvar_36.z))
  ) && (xlv_TEXCOORD2.y >= tmpvar_36.y)) && (xlv_TEXCOORD2.y <= (tmpvar_36.y + tmpvar_36.w)));
  mediump float tmpvar_38;
  if (tmpvar_37) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  mediump float tmpvar_39;
  if ((((
    (_BorderWidths[0] > 0.0)
   || 
    (_BorderWidths[1] > 0.0)
  ) || (_BorderWidths[2] > 0.0)) || (_BorderWidths[3] > 0.0))) {
    mediump float tmpvar_40;
    if (tmpvar_19) {
      tmpvar_40 = 1.0;
    } else {
      tmpvar_40 = tmpvar_38;
    };
    tmpvar_39 = tmpvar_40;
  } else {
    tmpvar_39 = 1.0;
  };
  borderAlpha_3 = tmpvar_39;
  col_9.w = (col_9.w * borderAlpha_3);
  lowp float tmpvar_41;
  tmpvar_41 = texture2D (_GUIClipTexture, xlv_TEXCOORD1).w;
  clipAlpha_2 = tmpvar_41;
  col_9.w = (col_9.w * clipAlpha_2);
  if ((_SrcBlend != 5)) {
    col_9.xyz = (col_9.xyz * ((cornerAlpha_4 * borderAlpha_3) * clipAlpha_2));
  };
  tmpvar_1 = col_9;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 hlslcc_mtx4x4unity_GUIClipTextureMatrix[4];
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
vec2 u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xy = u_xlat0.yy * hlslcc_mtx4x4unity_MatrixV[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[0].xy * u_xlat0.xx + u_xlat1.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[3].xy * u_xlat0.ww + u_xlat0.xy;
    u_xlat2.xy = u_xlat0.yy * hlslcc_mtx4x4unity_GUIClipTextureMatrix[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_GUIClipTextureMatrix[0].xy * u_xlat0.xx + u_xlat2.xy;
    vs_TEXCOORD1.xy = u_xlat0.xy + hlslcc_mtx4x4unity_GUIClipTextureMatrix[3].xy;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD2 = in_POSITION0;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	int _ManualTex2SRGB;
uniform 	int _SrcBlend;
uniform 	float _CornerRadiuses[4];
uniform 	float _BorderWidths[4];
uniform 	float _Rect[4];
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _GUIClipTexture;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
bvec2 u_xlatb0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
bvec2 u_xlatb1;
vec4 u_xlat2;
mediump vec3 u_xlat16_2;
ivec2 u_xlati2;
vec3 u_xlat3;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
bvec3 u_xlatb6;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
bool u_xlatb13;
vec2 u_xlat15;
vec2 u_xlat16;
float u_xlat18;
bool u_xlatb18;
int u_xlati19;
mediump float u_xlat16_23;
void main()
{
    u_xlat0.x = _BorderWidths[0];
    u_xlat1.x = _BorderWidths[2];
    u_xlat12 = vs_TEXCOORD2.x + (-_Rect[0]);
    u_xlat12 = (-_Rect[2]) * 0.5 + u_xlat12;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(0.0>=u_xlat12);
#else
    u_xlatb12 = 0.0>=u_xlat12;
#endif
    u_xlat18 = _Rect[0] + _Rect[2];
    u_xlat13 = vs_TEXCOORD2.y + (-_Rect[1]);
    u_xlat13 = (-_Rect[3]) * 0.5 + u_xlat13;
#ifdef UNITY_ADRENO_ES3
    u_xlatb13 = !!(0.0>=u_xlat13);
#else
    u_xlatb13 = 0.0>=u_xlat13;
#endif
    u_xlati2.xy = (bool(u_xlatb13)) ? ivec2(0, 1) : ivec2(3, 2);
    u_xlati19 = (u_xlatb12) ? u_xlati2.x : u_xlati2.y;
    u_xlat1.y = u_xlat18 + (-_CornerRadiuses[u_xlati19]);
    u_xlat0.y = _Rect[0] + _CornerRadiuses[u_xlati19];
    u_xlat2.xy = (bool(u_xlatb12)) ? u_xlat0.xy : u_xlat1.xy;
    u_xlat15.x = _BorderWidths[1];
    u_xlat16.x = _BorderWidths[3];
    u_xlat0.x = _Rect[1] + _Rect[3];
    u_xlat16.y = u_xlat0.x + (-_CornerRadiuses[u_xlati19]);
    u_xlat15.y = _Rect[1] + _CornerRadiuses[u_xlati19];
    u_xlat2.zw = (bool(u_xlatb13)) ? u_xlat15.xy : u_xlat16.xy;
    u_xlat0.xy = (-u_xlat2.xz) + vec2(_CornerRadiuses[u_xlati19]);
    u_xlat18 = u_xlat0.x / u_xlat0.y;
    u_xlat3.xy = vec2((-u_xlat2.y) + vs_TEXCOORD2.x, (-u_xlat2.w) + vs_TEXCOORD2.y);
    u_xlat3.z = u_xlat18 * u_xlat3.y;
    u_xlat18 = dot(u_xlat3.xz, u_xlat3.xz);
    u_xlat1.x = dot(u_xlat3.xy, u_xlat3.xy);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat1.x = u_xlat1.x + (-_CornerRadiuses[u_xlati19]);
    u_xlat18 = sqrt(u_xlat18);
    u_xlat18 = (-u_xlat0.x) + u_xlat18;
    u_xlatb0.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat0.xyxx).xy;
    u_xlatb0.x = u_xlatb0.y && u_xlatb0.x;
    u_xlat6.x = dFdx(vs_TEXCOORD2.x);
    u_xlat6.x = float(1.0) / abs(u_xlat6.x);
    u_xlat18 = u_xlat18 * u_xlat6.x + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat18 = min(max(u_xlat18, 0.0), 1.0);
#else
    u_xlat18 = clamp(u_xlat18, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat1.x * u_xlat6.x + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = (u_xlatb0.x) ? u_xlat18 : 1.0;
    u_xlatb1.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat2.xzxx).xy;
    u_xlatb18 = u_xlatb1.y || u_xlatb1.x;
    u_xlat0.x = u_xlatb18 ? u_xlat0.x : float(0.0);
    u_xlat6.x = u_xlatb18 ? u_xlat6.x : float(0.0);
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(u_xlat6.x==0.0);
#else
    u_xlatb18 = u_xlat6.x==0.0;
#endif
    u_xlat6.x = (-u_xlat6.x) + 1.0;
    u_xlat0.x = (u_xlatb18) ? u_xlat0.x : u_xlat6.x;
    u_xlatb6.xz = greaterThanEqual(u_xlat2.yyww, vs_TEXCOORD2.xxyy).xz;
    u_xlatb1.xy = greaterThanEqual(vs_TEXCOORD2.xyxx, u_xlat2.ywyy).xy;
    u_xlatb6.x = (u_xlatb12) ? u_xlatb6.x : u_xlatb1.x;
    u_xlatb12 = (u_xlatb13) ? u_xlatb6.z : u_xlatb1.y;
    u_xlatb6.x = u_xlatb12 && u_xlatb6.x;
    u_xlat0.x = (u_xlatb6.x) ? u_xlat0.x : 1.0;
    u_xlat12 = _BorderWidths[0] + _BorderWidths[2];
    u_xlat12 = (-u_xlat12) + _Rect[2];
    u_xlat18 = _BorderWidths[0] + _Rect[0];
    u_xlat12 = u_xlat12 + u_xlat18;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(vs_TEXCOORD2.x>=u_xlat18);
#else
    u_xlatb18 = vs_TEXCOORD2.x>=u_xlat18;
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat12>=vs_TEXCOORD2.x);
#else
    u_xlatb12 = u_xlat12>=vs_TEXCOORD2.x;
#endif
    u_xlatb12 = u_xlatb12 && u_xlatb18;
    u_xlat18 = _BorderWidths[1] + _Rect[1];
#ifdef UNITY_ADRENO_ES3
    u_xlatb1.x = !!(vs_TEXCOORD2.y>=u_xlat18);
#else
    u_xlatb1.x = vs_TEXCOORD2.y>=u_xlat18;
#endif
    u_xlatb12 = u_xlatb12 && u_xlatb1.x;
    u_xlat1.x = _BorderWidths[1] + _BorderWidths[3];
    u_xlat1.x = (-u_xlat1.x) + _Rect[3];
    u_xlat18 = u_xlat18 + u_xlat1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(u_xlat18>=vs_TEXCOORD2.y);
#else
    u_xlatb18 = u_xlat18>=vs_TEXCOORD2.y;
#endif
    u_xlatb12 = u_xlatb18 && u_xlatb12;
    u_xlat12 = (u_xlatb12) ? 0.0 : 1.0;
    u_xlat6.x = (u_xlatb6.x) ? 1.0 : u_xlat12;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(0.0<_BorderWidths[0]);
#else
    u_xlatb12 = 0.0<_BorderWidths[0];
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(0.0<_BorderWidths[1]);
#else
    u_xlatb18 = 0.0<_BorderWidths[1];
#endif
    u_xlatb12 = u_xlatb18 || u_xlatb12;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(0.0<_BorderWidths[2]);
#else
    u_xlatb18 = 0.0<_BorderWidths[2];
#endif
    u_xlatb12 = u_xlatb18 || u_xlatb12;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(0.0<_BorderWidths[3]);
#else
    u_xlatb18 = 0.0<_BorderWidths[3];
#endif
    u_xlatb12 = u_xlatb18 || u_xlatb12;
    u_xlat6.x = (u_xlatb12) ? u_xlat6.x : 1.0;
    u_xlat0.z = u_xlat6.x * u_xlat0.x;
    u_xlat6.z = texture(_GUIClipTexture, vs_TEXCOORD1.xy).w;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat16_5.xyz = max(u_xlat10_1.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_2.xyz = log2(u_xlat16_5.xyz);
    u_xlat16_2.xyz = u_xlat16_2.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
    u_xlat16_2.xyz = exp2(u_xlat16_2.xyz);
    u_xlat16_2.xyz = u_xlat16_2.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
    u_xlat2.xyz = max(u_xlat16_2.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_5.xyz = (_ManualTex2SRGB != 0) ? u_xlat2.xyz : u_xlat10_1.xyz;
    u_xlat16_23 = u_xlat10_1.w * vs_COLOR0.w;
    u_xlat0.x = u_xlat0.x * u_xlat16_23;
    u_xlat0.xz = u_xlat6.xz * u_xlat0.xz;
    u_xlat0.x = u_xlat6.z * u_xlat0.x;
    SV_Target0.w = u_xlat0.x;
    u_xlat16_5.xyz = u_xlat16_5.xyz * vs_COLOR0.xyz;
    u_xlat0.xyz = u_xlat0.zzz * u_xlat16_5.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(_SrcBlend!=5);
#else
    u_xlatb18 = _SrcBlend!=5;
#endif
    SV_Target0.xyz = (bool(u_xlatb18)) ? u_xlat0.xyz : u_xlat16_5.xyz;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles " {
""
}
SubProgram "gles3 " {
""
}
}
}
}
SubShader {
 Pass {
  Blend Zero Zero, Zero Zero
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 99788
Program "vp" {
SubProgram "gles " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 unity_GUIClipTextureMatrix;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 1.0);
  tmpvar_4.xy = (unity_MatrixV * (unity_ObjectToWorld * tmpvar_2)).xy;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (unity_GUIClipTextureMatrix * tmpvar_4).xy;
  xlv_TEXCOORD2 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_OES_standard_derivatives : enable
uniform sampler2D _MainTex;
uniform sampler2D _GUIClipTexture;
uniform bool _ManualTex2SRGB;
uniform highp int _SrcBlend;
uniform highp float _CornerRadiuses[4];
uniform highp float _BorderWidths[4];
uniform highp float _Rect[4];
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  highp float clipAlpha_2;
  highp float borderAlpha_3;
  highp float cornerAlpha_4;
  highp vec2 center_5;
  highp int radiusIndex_6;
  highp float bw2_7;
  highp float bw1_8;
  mediump vec4 col_9;
  highp float tmpvar_10;
  tmpvar_10 = (1.0/(abs(dFdx(xlv_TEXCOORD2.x))));
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_MainTex, xlv_TEXCOORD0);
  col_9 = tmpvar_11;
  if (_ManualTex2SRGB) {
    col_9.xyz = max (((1.055 * 
      pow (max (col_9.xyz, vec3(0.0, 0.0, 0.0)), vec3(0.4166667, 0.4166667, 0.4166667))
    ) - 0.055), vec3(0.0, 0.0, 0.0));
  };
  col_9 = (col_9 * xlv_COLOR);
  bool tmpvar_12;
  tmpvar_12 = (((xlv_TEXCOORD2.x - _Rect[0]) - (_Rect[2] / 2.0)) <= 0.0);
  bool tmpvar_13;
  tmpvar_13 = (((xlv_TEXCOORD2.y - _Rect[1]) - (_Rect[3] / 2.0)) <= 0.0);
  bw1_8 = _BorderWidths[0];
  bw2_7 = _BorderWidths[1];
  radiusIndex_6 = 0;
  if (tmpvar_12) {
    highp int tmpvar_14;
    if (tmpvar_13) {
      tmpvar_14 = 0;
    } else {
      tmpvar_14 = 3;
    };
    radiusIndex_6 = tmpvar_14;
  } else {
    highp int tmpvar_15;
    if (tmpvar_13) {
      tmpvar_15 = 1;
    } else {
      tmpvar_15 = 2;
    };
    radiusIndex_6 = tmpvar_15;
  };
  highp float tmpvar_16;
  tmpvar_16 = _CornerRadiuses[radiusIndex_6];
  highp vec2 tmpvar_17;
  tmpvar_17.x = (_Rect[0] + tmpvar_16);
  tmpvar_17.y = (_Rect[1] + tmpvar_16);
  center_5 = tmpvar_17;
  if (!(tmpvar_12)) {
    center_5.x = ((_Rect[0] + _Rect[2]) - tmpvar_16);
    bw1_8 = _BorderWidths[2];
  };
  if (!(tmpvar_13)) {
    center_5.y = ((_Rect[1] + _Rect[3]) - tmpvar_16);
    bw2_7 = _BorderWidths[3];
  };
  bool tmpvar_18;
  if (tmpvar_12) {
    tmpvar_18 = (xlv_TEXCOORD2.x <= center_5.x);
  } else {
    tmpvar_18 = (xlv_TEXCOORD2.x >= center_5.x);
  };
  bool tmpvar_19;
  if (tmpvar_18) {
    bool tmpvar_20;
    if (tmpvar_13) {
      tmpvar_20 = (xlv_TEXCOORD2.y <= center_5.y);
    } else {
      tmpvar_20 = (xlv_TEXCOORD2.y >= center_5.y);
    };
    tmpvar_19 = tmpvar_20;
  } else {
    tmpvar_19 = bool(0);
  };
  mediump float tmpvar_21;
  if (tmpvar_19) {
    mediump float rawDist_22;
    highp vec2 v_23;
    bool tmpvar_24;
    tmpvar_24 = ((bw1_8 > 0.0) || (bw2_7 > 0.0));
    highp vec2 tmpvar_25;
    tmpvar_25 = (xlv_TEXCOORD2.xy - center_5);
    v_23 = tmpvar_25;
    highp float tmpvar_26;
    tmpvar_26 = ((sqrt(
      dot (tmpvar_25, tmpvar_25)
    ) - tmpvar_16) * tmpvar_10);
    mediump float tmpvar_27;
    if (tmpvar_24) {
      highp float tmpvar_28;
      tmpvar_28 = clamp ((0.5 + tmpvar_26), 0.0, 1.0);
      tmpvar_27 = tmpvar_28;
    } else {
      tmpvar_27 = 0.0;
    };
    highp float tmpvar_29;
    tmpvar_29 = (tmpvar_16 - bw1_8);
    highp float tmpvar_30;
    tmpvar_30 = (tmpvar_16 - bw2_7);
    v_23.y = (tmpvar_25.y * (tmpvar_29 / tmpvar_30));
    highp float tmpvar_31;
    tmpvar_31 = ((sqrt(
      dot (v_23, v_23)
    ) - tmpvar_29) * tmpvar_10);
    rawDist_22 = tmpvar_31;
    mediump float tmpvar_32;
    tmpvar_32 = clamp ((rawDist_22 + 0.5), 0.0, 1.0);
    mediump float tmpvar_33;
    if (tmpvar_24) {
      mediump float tmpvar_34;
      if (((tmpvar_29 > 0.0) && (tmpvar_30 > 0.0))) {
        tmpvar_34 = tmpvar_32;
      } else {
        tmpvar_34 = 1.0;
      };
      tmpvar_33 = tmpvar_34;
    } else {
      tmpvar_33 = 0.0;
    };
    mediump float tmpvar_35;
    if ((tmpvar_27 == 0.0)) {
      tmpvar_35 = tmpvar_33;
    } else {
      tmpvar_35 = (1.0 - tmpvar_27);
    };
    tmpvar_21 = tmpvar_35;
  } else {
    tmpvar_21 = 1.0;
  };
  cornerAlpha_4 = tmpvar_21;
  col_9.w = (col_9.w * cornerAlpha_4);
  highp vec4 tmpvar_36;
  tmpvar_36.x = (_Rect[0] + _BorderWidths[0]);
  tmpvar_36.y = (_Rect[1] + _BorderWidths[1]);
  tmpvar_36.z = (_Rect[2] - (_BorderWidths[0] + _BorderWidths[2]));
  tmpvar_36.w = (_Rect[3] - (_BorderWidths[1] + _BorderWidths[3]));
  bool tmpvar_37;
  tmpvar_37 = (((
    (xlv_TEXCOORD2.x >= tmpvar_36.x)
   && 
    (xlv_TEXCOORD2.x <= (tmpvar_36.x + tmpvar_36.z))
  ) && (xlv_TEXCOORD2.y >= tmpvar_36.y)) && (xlv_TEXCOORD2.y <= (tmpvar_36.y + tmpvar_36.w)));
  mediump float tmpvar_38;
  if (tmpvar_37) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  mediump float tmpvar_39;
  if ((((
    (_BorderWidths[0] > 0.0)
   || 
    (_BorderWidths[1] > 0.0)
  ) || (_BorderWidths[2] > 0.0)) || (_BorderWidths[3] > 0.0))) {
    mediump float tmpvar_40;
    if (tmpvar_19) {
      tmpvar_40 = 1.0;
    } else {
      tmpvar_40 = tmpvar_38;
    };
    tmpvar_39 = tmpvar_40;
  } else {
    tmpvar_39 = 1.0;
  };
  borderAlpha_3 = tmpvar_39;
  col_9.w = (col_9.w * borderAlpha_3);
  lowp float tmpvar_41;
  tmpvar_41 = texture2D (_GUIClipTexture, xlv_TEXCOORD1).w;
  clipAlpha_2 = tmpvar_41;
  col_9.w = (col_9.w * clipAlpha_2);
  if ((_SrcBlend != 5)) {
    col_9.xyz = (col_9.xyz * ((cornerAlpha_4 * borderAlpha_3) * clipAlpha_2));
  };
  tmpvar_1 = col_9;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 hlslcc_mtx4x4unity_GUIClipTextureMatrix[4];
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
vec2 u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xy = u_xlat0.yy * hlslcc_mtx4x4unity_MatrixV[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[0].xy * u_xlat0.xx + u_xlat1.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[3].xy * u_xlat0.ww + u_xlat0.xy;
    u_xlat2.xy = u_xlat0.yy * hlslcc_mtx4x4unity_GUIClipTextureMatrix[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_GUIClipTextureMatrix[0].xy * u_xlat0.xx + u_xlat2.xy;
    vs_TEXCOORD1.xy = u_xlat0.xy + hlslcc_mtx4x4unity_GUIClipTextureMatrix[3].xy;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD2 = in_POSITION0;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	int _ManualTex2SRGB;
uniform 	int _SrcBlend;
uniform 	float _CornerRadiuses[4];
uniform 	float _BorderWidths[4];
uniform 	float _Rect[4];
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _GUIClipTexture;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
bvec2 u_xlatb0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
bvec2 u_xlatb1;
vec4 u_xlat2;
mediump vec3 u_xlat16_2;
ivec2 u_xlati2;
vec3 u_xlat3;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
bvec3 u_xlatb6;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
bool u_xlatb13;
vec2 u_xlat15;
vec2 u_xlat16;
float u_xlat18;
bool u_xlatb18;
int u_xlati19;
mediump float u_xlat16_23;
void main()
{
    u_xlat0.x = _BorderWidths[0];
    u_xlat1.x = _BorderWidths[2];
    u_xlat12 = vs_TEXCOORD2.x + (-_Rect[0]);
    u_xlat12 = (-_Rect[2]) * 0.5 + u_xlat12;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(0.0>=u_xlat12);
#else
    u_xlatb12 = 0.0>=u_xlat12;
#endif
    u_xlat18 = _Rect[0] + _Rect[2];
    u_xlat13 = vs_TEXCOORD2.y + (-_Rect[1]);
    u_xlat13 = (-_Rect[3]) * 0.5 + u_xlat13;
#ifdef UNITY_ADRENO_ES3
    u_xlatb13 = !!(0.0>=u_xlat13);
#else
    u_xlatb13 = 0.0>=u_xlat13;
#endif
    u_xlati2.xy = (bool(u_xlatb13)) ? ivec2(0, 1) : ivec2(3, 2);
    u_xlati19 = (u_xlatb12) ? u_xlati2.x : u_xlati2.y;
    u_xlat1.y = u_xlat18 + (-_CornerRadiuses[u_xlati19]);
    u_xlat0.y = _Rect[0] + _CornerRadiuses[u_xlati19];
    u_xlat2.xy = (bool(u_xlatb12)) ? u_xlat0.xy : u_xlat1.xy;
    u_xlat15.x = _BorderWidths[1];
    u_xlat16.x = _BorderWidths[3];
    u_xlat0.x = _Rect[1] + _Rect[3];
    u_xlat16.y = u_xlat0.x + (-_CornerRadiuses[u_xlati19]);
    u_xlat15.y = _Rect[1] + _CornerRadiuses[u_xlati19];
    u_xlat2.zw = (bool(u_xlatb13)) ? u_xlat15.xy : u_xlat16.xy;
    u_xlat0.xy = (-u_xlat2.xz) + vec2(_CornerRadiuses[u_xlati19]);
    u_xlat18 = u_xlat0.x / u_xlat0.y;
    u_xlat3.xy = vec2((-u_xlat2.y) + vs_TEXCOORD2.x, (-u_xlat2.w) + vs_TEXCOORD2.y);
    u_xlat3.z = u_xlat18 * u_xlat3.y;
    u_xlat18 = dot(u_xlat3.xz, u_xlat3.xz);
    u_xlat1.x = dot(u_xlat3.xy, u_xlat3.xy);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat1.x = u_xlat1.x + (-_CornerRadiuses[u_xlati19]);
    u_xlat18 = sqrt(u_xlat18);
    u_xlat18 = (-u_xlat0.x) + u_xlat18;
    u_xlatb0.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat0.xyxx).xy;
    u_xlatb0.x = u_xlatb0.y && u_xlatb0.x;
    u_xlat6.x = dFdx(vs_TEXCOORD2.x);
    u_xlat6.x = float(1.0) / abs(u_xlat6.x);
    u_xlat18 = u_xlat18 * u_xlat6.x + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat18 = min(max(u_xlat18, 0.0), 1.0);
#else
    u_xlat18 = clamp(u_xlat18, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat1.x * u_xlat6.x + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = (u_xlatb0.x) ? u_xlat18 : 1.0;
    u_xlatb1.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat2.xzxx).xy;
    u_xlatb18 = u_xlatb1.y || u_xlatb1.x;
    u_xlat0.x = u_xlatb18 ? u_xlat0.x : float(0.0);
    u_xlat6.x = u_xlatb18 ? u_xlat6.x : float(0.0);
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(u_xlat6.x==0.0);
#else
    u_xlatb18 = u_xlat6.x==0.0;
#endif
    u_xlat6.x = (-u_xlat6.x) + 1.0;
    u_xlat0.x = (u_xlatb18) ? u_xlat0.x : u_xlat6.x;
    u_xlatb6.xz = greaterThanEqual(u_xlat2.yyww, vs_TEXCOORD2.xxyy).xz;
    u_xlatb1.xy = greaterThanEqual(vs_TEXCOORD2.xyxx, u_xlat2.ywyy).xy;
    u_xlatb6.x = (u_xlatb12) ? u_xlatb6.x : u_xlatb1.x;
    u_xlatb12 = (u_xlatb13) ? u_xlatb6.z : u_xlatb1.y;
    u_xlatb6.x = u_xlatb12 && u_xlatb6.x;
    u_xlat0.x = (u_xlatb6.x) ? u_xlat0.x : 1.0;
    u_xlat12 = _BorderWidths[0] + _BorderWidths[2];
    u_xlat12 = (-u_xlat12) + _Rect[2];
    u_xlat18 = _BorderWidths[0] + _Rect[0];
    u_xlat12 = u_xlat12 + u_xlat18;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(vs_TEXCOORD2.x>=u_xlat18);
#else
    u_xlatb18 = vs_TEXCOORD2.x>=u_xlat18;
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat12>=vs_TEXCOORD2.x);
#else
    u_xlatb12 = u_xlat12>=vs_TEXCOORD2.x;
#endif
    u_xlatb12 = u_xlatb12 && u_xlatb18;
    u_xlat18 = _BorderWidths[1] + _Rect[1];
#ifdef UNITY_ADRENO_ES3
    u_xlatb1.x = !!(vs_TEXCOORD2.y>=u_xlat18);
#else
    u_xlatb1.x = vs_TEXCOORD2.y>=u_xlat18;
#endif
    u_xlatb12 = u_xlatb12 && u_xlatb1.x;
    u_xlat1.x = _BorderWidths[1] + _BorderWidths[3];
    u_xlat1.x = (-u_xlat1.x) + _Rect[3];
    u_xlat18 = u_xlat18 + u_xlat1.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(u_xlat18>=vs_TEXCOORD2.y);
#else
    u_xlatb18 = u_xlat18>=vs_TEXCOORD2.y;
#endif
    u_xlatb12 = u_xlatb18 && u_xlatb12;
    u_xlat12 = (u_xlatb12) ? 0.0 : 1.0;
    u_xlat6.x = (u_xlatb6.x) ? 1.0 : u_xlat12;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(0.0<_BorderWidths[0]);
#else
    u_xlatb12 = 0.0<_BorderWidths[0];
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(0.0<_BorderWidths[1]);
#else
    u_xlatb18 = 0.0<_BorderWidths[1];
#endif
    u_xlatb12 = u_xlatb18 || u_xlatb12;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(0.0<_BorderWidths[2]);
#else
    u_xlatb18 = 0.0<_BorderWidths[2];
#endif
    u_xlatb12 = u_xlatb18 || u_xlatb12;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(0.0<_BorderWidths[3]);
#else
    u_xlatb18 = 0.0<_BorderWidths[3];
#endif
    u_xlatb12 = u_xlatb18 || u_xlatb12;
    u_xlat6.x = (u_xlatb12) ? u_xlat6.x : 1.0;
    u_xlat0.z = u_xlat6.x * u_xlat0.x;
    u_xlat6.z = texture(_GUIClipTexture, vs_TEXCOORD1.xy).w;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat16_5.xyz = max(u_xlat10_1.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_2.xyz = log2(u_xlat16_5.xyz);
    u_xlat16_2.xyz = u_xlat16_2.xyz * vec3(0.416666657, 0.416666657, 0.416666657);
    u_xlat16_2.xyz = exp2(u_xlat16_2.xyz);
    u_xlat16_2.xyz = u_xlat16_2.xyz * vec3(1.05499995, 1.05499995, 1.05499995) + vec3(-0.0549999997, -0.0549999997, -0.0549999997);
    u_xlat2.xyz = max(u_xlat16_2.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_5.xyz = (_ManualTex2SRGB != 0) ? u_xlat2.xyz : u_xlat10_1.xyz;
    u_xlat16_23 = u_xlat10_1.w * vs_COLOR0.w;
    u_xlat0.x = u_xlat0.x * u_xlat16_23;
    u_xlat0.xz = u_xlat6.xz * u_xlat0.xz;
    u_xlat0.x = u_xlat6.z * u_xlat0.x;
    SV_Target0.w = u_xlat0.x;
    u_xlat16_5.xyz = u_xlat16_5.xyz * vs_COLOR0.xyz;
    u_xlat0.xyz = u_xlat0.zzz * u_xlat16_5.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb18 = !!(_SrcBlend!=5);
#else
    u_xlatb18 = _SrcBlend!=5;
#endif
    SV_Target0.xyz = (bool(u_xlatb18)) ? u_xlat0.xyz : u_xlat16_5.xyz;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles " {
""
}
SubProgram "gles3 " {
""
}
}
}
}
Fallback "Hidden/Internal-GUITextureClip"
}