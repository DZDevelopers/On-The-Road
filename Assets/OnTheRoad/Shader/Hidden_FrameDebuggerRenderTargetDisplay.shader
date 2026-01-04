//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/FrameDebuggerRenderTargetDisplay" {
Properties {
_MainTex ("", any) = "white" { }
}
SubShader {
 Tags { "ForceSupported" = "true" }
 Pass {
  Tags { "ForceSupported" = "true" }
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 555
Program "vp" {
SubProgram "gles " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _Channels;
uniform mediump vec4 _Levels;
uniform bool _UndoOutputSRGB;
uniform highp sampler2D _MainTex;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 tex_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0.xy);
  tex_1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  mediump vec4 col_4;
  col_4 = (tex_1 - _Levels.xxxx);
  col_4 = (col_4 / (_Levels.yyyy - _Levels.xxxx));
  col_4 = (col_4 * _Channels);
  lowp float tmpvar_5;
  tmpvar_5 = dot (_Channels, vec4(1.0, 1.0, 1.0, 1.0));
  if ((tmpvar_5 == 1.0)) {
    col_4 = vec4(dot (col_4, vec4(1.0, 1.0, 1.0, 1.0)));
  };
  if (_UndoOutputSRGB) {
    mediump vec3 tmpvar_6;
    tmpvar_6 = clamp (col_4.xyz, 0.0, 1.0);
    col_4.xyz = (tmpvar_6 * ((tmpvar_6 * 
      ((tmpvar_6 * 0.305306) + 0.6821711)
    ) + 0.01252288));
  };
  tmpvar_3 = col_4;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
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
    vs_TEXCOORD0.xyz = in_TEXCOORD0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _Channels;
uniform 	mediump vec4 _Levels;
uniform 	int _UndoOutputSRGB;
uniform highp sampler2D _MainTex;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
mediump vec3 u_xlat16_1;
vec3 u_xlat2;
mediump vec3 u_xlat16_2;
bool u_xlatb2;
mediump float u_xlat16_4;
void main()
{
    u_xlat0 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat16_0 = u_xlat0 + (-_Levels.xxxx);
    u_xlat16_1.x = (-_Levels.x) + _Levels.y;
    u_xlat16_0 = u_xlat16_0 / u_xlat16_1.xxxx;
    u_xlat16_0 = u_xlat16_0 * _Channels;
    u_xlat16_1.x = dot(u_xlat16_0, vec4(1.0, 1.0, 1.0, 1.0));
    u_xlat16_4 = dot(_Channels, vec4(1.0, 1.0, 1.0, 1.0));
#ifdef UNITY_ADRENO_ES3
    u_xlatb2 = !!(u_xlat16_4==1.0);
#else
    u_xlatb2 = u_xlat16_4==1.0;
#endif
    u_xlat16_0 = (bool(u_xlatb2)) ? u_xlat16_1.xxxx : u_xlat16_0;
    u_xlat16_1.xyz = u_xlat16_0.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
#else
    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
#endif
    u_xlat16_2.xyz = u_xlat16_1.xyz * vec3(0.305306017, 0.305306017, 0.305306017) + vec3(0.682171106, 0.682171106, 0.682171106);
    u_xlat16_2.xyz = u_xlat16_1.xyz * u_xlat16_2.xyz + vec3(0.0125228781, 0.0125228781, 0.0125228781);
    u_xlat2.xyz = u_xlat16_1.xyz * u_xlat16_2.xyz;
    SV_Target0.xyz = (_UndoOutputSRGB != 0) ? u_xlat2.xyz : u_xlat16_0.xyz;
    SV_Target0.w = u_xlat16_0.w;
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
 Pass {
  Tags { "ForceSupported" = "true" }
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 97613
Program "vp" {
SubProgram "gles " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _Channels;
uniform mediump vec4 _Levels;
uniform bool _UndoOutputSRGB;
uniform highp samplerCube _MainTex;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 tex_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = textureCube (_MainTex, xlv_TEXCOORD0);
  tex_1 = tmpvar_2;
  lowp vec4 tmpvar_3;
  mediump vec4 col_4;
  col_4 = (tex_1 - _Levels.xxxx);
  col_4 = (col_4 / (_Levels.yyyy - _Levels.xxxx));
  col_4 = (col_4 * _Channels);
  lowp float tmpvar_5;
  tmpvar_5 = dot (_Channels, vec4(1.0, 1.0, 1.0, 1.0));
  if ((tmpvar_5 == 1.0)) {
    col_4 = vec4(dot (col_4, vec4(1.0, 1.0, 1.0, 1.0)));
  };
  if (_UndoOutputSRGB) {
    mediump vec3 tmpvar_6;
    tmpvar_6 = clamp (col_4.xyz, 0.0, 1.0);
    col_4.xyz = (tmpvar_6 * ((tmpvar_6 * 
      ((tmpvar_6 * 0.305306) + 0.6821711)
    ) + 0.01252288));
  };
  tmpvar_3 = col_4;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
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
    vs_TEXCOORD0.xyz = in_TEXCOORD0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _Channels;
uniform 	mediump vec4 _Levels;
uniform 	int _UndoOutputSRGB;
uniform highp samplerCube _MainTex;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
mediump vec3 u_xlat16_1;
vec3 u_xlat2;
mediump vec3 u_xlat16_2;
bool u_xlatb2;
mediump float u_xlat16_4;
void main()
{
    u_xlat0 = texture(_MainTex, vs_TEXCOORD0.xyz);
    u_xlat16_0 = u_xlat0 + (-_Levels.xxxx);
    u_xlat16_1.x = (-_Levels.x) + _Levels.y;
    u_xlat16_0 = u_xlat16_0 / u_xlat16_1.xxxx;
    u_xlat16_0 = u_xlat16_0 * _Channels;
    u_xlat16_1.x = dot(u_xlat16_0, vec4(1.0, 1.0, 1.0, 1.0));
    u_xlat16_4 = dot(_Channels, vec4(1.0, 1.0, 1.0, 1.0));
#ifdef UNITY_ADRENO_ES3
    u_xlatb2 = !!(u_xlat16_4==1.0);
#else
    u_xlatb2 = u_xlat16_4==1.0;
#endif
    u_xlat16_0 = (bool(u_xlatb2)) ? u_xlat16_1.xxxx : u_xlat16_0;
    u_xlat16_1.xyz = u_xlat16_0.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
#else
    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
#endif
    u_xlat16_2.xyz = u_xlat16_1.xyz * vec3(0.305306017, 0.305306017, 0.305306017) + vec3(0.682171106, 0.682171106, 0.682171106);
    u_xlat16_2.xyz = u_xlat16_1.xyz * u_xlat16_2.xyz + vec3(0.0125228781, 0.0125228781, 0.0125228781);
    u_xlat2.xyz = u_xlat16_1.xyz * u_xlat16_2.xyz;
    SV_Target0.xyz = (_UndoOutputSRGB != 0) ? u_xlat2.xyz : u_xlat16_0.xyz;
    SV_Target0.w = u_xlat16_0.w;
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
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 154055
Program "vp" {
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
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
    vs_TEXCOORD0.xyz = in_TEXCOORD0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _Channels;
uniform 	mediump vec4 _Levels;
uniform 	int _UndoOutputSRGB;
uniform lowp sampler2DArray _MainTex;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
vec3 u_xlat2;
mediump vec3 u_xlat16_2;
bool u_xlatb2;
mediump float u_xlat16_4;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xyz);
    u_xlat16_0 = u_xlat10_0 + (-_Levels.xxxx);
    u_xlat16_1.x = (-_Levels.x) + _Levels.y;
    u_xlat16_0 = u_xlat16_0 / u_xlat16_1.xxxx;
    u_xlat16_0 = u_xlat16_0 * _Channels;
    u_xlat16_1.x = dot(u_xlat16_0, vec4(1.0, 1.0, 1.0, 1.0));
    u_xlat16_4 = dot(_Channels, vec4(1.0, 1.0, 1.0, 1.0));
#ifdef UNITY_ADRENO_ES3
    u_xlatb2 = !!(u_xlat16_4==1.0);
#else
    u_xlatb2 = u_xlat16_4==1.0;
#endif
    u_xlat16_0 = (bool(u_xlatb2)) ? u_xlat16_1.xxxx : u_xlat16_0;
    u_xlat16_1.xyz = u_xlat16_0.xyz;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_1.xyz = min(max(u_xlat16_1.xyz, 0.0), 1.0);
#else
    u_xlat16_1.xyz = clamp(u_xlat16_1.xyz, 0.0, 1.0);
#endif
    u_xlat16_2.xyz = u_xlat16_1.xyz * vec3(0.305306017, 0.305306017, 0.305306017) + vec3(0.682171106, 0.682171106, 0.682171106);
    u_xlat16_2.xyz = u_xlat16_1.xyz * u_xlat16_2.xyz + vec3(0.0125228781, 0.0125228781, 0.0125228781);
    u_xlat2.xyz = u_xlat16_1.xyz * u_xlat16_2.xyz;
    SV_Target0.xyz = (_UndoOutputSRGB != 0) ? u_xlat2.xyz : u_xlat16_0.xyz;
    SV_Target0.w = u_xlat16_0.w;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles3 " {
""
}
}
}
}
}