shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform bool gaydar = false;
uniform bool has_tint = true;
uniform vec3 tint : source_color = vec3(0.415, 0.68, 0.415);
uniform bool quantize = true;
uniform bool dithering = true;
uniform bool scanline = true;
uniform bool chromatic_abberation = true;
uniform float chromatic_abberation_amount = 1.;
uniform float darkest_black = 0.1;

uniform sampler2D colors;

const vec3 dithering_dark_grey = vec3(0.2);
const vec3 dithering_mid_grey = vec3(0.5);
const vec3 dithering_light_grey = vec3(0.8);


uniform float speed = 2.;
uniform float warp_amount = 1.0;
uniform float vignette_intensity = 0.4;
uniform float vignette_opacity : hint_range(0.0, 1.0) = 0.5;

varying float line_pos;
varying vec3 original_color;

const mat4 bayerIndex = mat4(
    vec4(00.0/16.0, 12.0/16.0, 03.0/16.0, 15.0/16.0),
    vec4(08.0/16.0, 04.0/16.0, 11.0/16.0, 07.0/16.0),
    vec4(02.0/16.0, 14.0/16.0, 01.0/16.0, 13.0/16.0),
    vec4(10.0/16.0, 06.0/16.0, 09.0/16.0, 05.0/16.0));

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453) - .5;
}

vec2 warp(vec2 uv, float warp_amounts) {
    vec2 delta = uv - 0.5;
    float delta2 = dot(delta.xy, delta.xy);
    float delta4 = delta2 * delta2;
    return uv + delta * (delta4 * warp_amounts);
}

// Screen border
float border(vec2 uv) {
    float radius = min(warp_amount, 0.08);
    radius = max(min(min(abs(radius * 2.0), abs(1.0)), abs(1.0)), 1e-5);
    vec2 abs_uv = abs(uv * 2.0 - 1.0) - vec2(1.0, 1.0) + radius;
    float dist = length(max(vec2(0.0), abs_uv)) / radius;
    return clamp(1.0 - smoothstep(0.96, 1.0, dist), 0.0, 1.0);
}

// Vignette effect
float vignette(vec2 uv) {
    uv *= 1.0 - uv.xy;
    float vig = uv.x * uv.y * 15.0;
    return pow(vig, vignette_intensity * vignette_opacity);
}

vec3 convertRgbToHsl(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 convertHslToRgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

bool threshold(float a, float b, float epsilon) {
	if (b < a + epsilon && b > a - epsilon) {
		return true;
	} else {
		return false;
	}
}

void fragment() {
	vec2 uv = warp(SCREEN_UV, warp_amount);
	line_pos = 0.0;
	vec3 output = vec3(0.);
	if (chromatic_abberation) {
		vec2 uvr = warp(SCREEN_UV, warp_amount);
		vec2 uvg = warp(SCREEN_UV, warp_amount + (0.5 * chromatic_abberation_amount));
		vec2 uvb = warp(SCREEN_UV, warp_amount + (1.2 * chromatic_abberation_amount));
		output.r = texture(screen_texture, uvr).r;
		output.g = texture(screen_texture, uvg).g;
		output.b = texture(screen_texture, uvb).b;
	} else {
		output = texture(screen_texture, uv).rgb;
	}

	if (quantize) {
		vec3 nearest = vec3(0.);
		float distance_to_nearest = distance(output, texture(colors, vec2(0,0)).rgb);
		ivec2 gradsize = textureSize(colors, 0);
		for (int i = 0; i < gradsize.x; i++){
			vec3 pos1 = texture(colors, vec2(float(i)/float(gradsize.x), 0)).rgb;
			float distance_to = distance(output, pos1);
			if (distance_to < distance_to_nearest){
				nearest = texture(colors, vec2(float(i)/float(gradsize.x), 0)).rgb;
				distance_to_nearest = distance_to;
			}
		}
		original_color = output;
		output = nearest;

	}

    // gamma correction
	if (dithering) {
 	    output = vec3(pow(output.rgb,vec3(2.2)) - 0.001);

	    // find bayer matrix entry based on fragment position
	    float bayerValue = bayerIndex[int(FRAGCOORD.x) % 4][int(FRAGCOORD.y) % 4];

		output = vec3(step(bayerValue,output.r),
	            step(bayerValue,output.g),
	            step(bayerValue,output.b));
	}
	if (scanline) {
		output += vec3(0.02);
		line_pos = mod(TIME * speed, 1.);
		if (line_pos > 1.) {
			line_pos = 0.;
		}
		if (threshold(uv.y, line_pos, 0.001)) {
			output *= 10.;

		}
		float pixel_brightness = mod(uv.y - TIME * speed, 1.);
		output *= pixel_brightness + 0.5;
		output += vec3(rand(uv + vec2(0.,sin(TIME)))) / 20.;
	}
	output += vec3(darkest_black - 0.02);
	output *= (sin(892. *  uv.y) + 4.) / 5.;

	if (gaydar) {
		output.r *= sin(5. * TIME) + 1./3.;
		output.g *= sin(5. * TIME - PI/1.5) + 1./3.;
		output.b *= sin(5. * TIME + PI/1.5) + 1./3.;
	} else if (has_tint) {
		output *= tint;
	}
	output.rgb *= border(uv);
	output.rgb *= vignette(uv);

	COLOR = vec4(output,1.);
}