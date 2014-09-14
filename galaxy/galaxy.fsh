// Fractal scrolling background

// Credits:
// Original version from https://www.shadertoy.com/view/MslGWN
// Inspired by JoshP's Simplicity shader: https://www.shadertoy.com/view/lslGWr
// Fractals from
// http://www.fractalforums.com/new-theories-and-research/very-simple-formula-for-fractal-patterns/
// Starfield from http://glsl.heroku.com/e#6904.0

// Ported for Love2D, optimizations and quality presets by Landon Manning and Jonathan Ringstad

extern float     global_time;           // shader playback time (in seconds)
extern float     global_time_sin;       // sine of playback time
extern vec2      offset;                // offset for panning around
extern vec4      freqs;                 // 4 frequency bands for flaring up colors

// Defines, substitute before compilation
#define FRONT_LAYER_QUALITY $FRONT_LAYER_QUALITY
#define BACK_LAYER_QUALITY $BACK_LAYER_QUALITY
#define FRONT_LAYER_INTENSITY $FRONT_LAYER_INTENSITY
#define BACK_LAYER_INTENSITY $BACK_LAYER_INTENSITY

// "EVOLVE" can be defined or not, to configure whether
// the fractal should evolve over time.
$DEFINE_EVOLVE


float field(in vec3 p,float s) {
	float strength = 7. + .03 * log(1.e-6 + fract(global_time_sin * FRONT_LAYER_INTENSITY));
	float accum = s/4.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < FRONT_LAYER_QUALITY; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) / 7.);
		accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
		tw += w;
		prev = mag;
	}
	return max(0., 5. * accum / tw - .7);
}

// Less iterations for second layer
float field2(in vec3 p, float s) {
	float strength = 7. + .03 * log(1.e-6 + fract(global_time_sin * BACK_LAYER_INTENSITY));
	float accum = s/4.;
	float prev = 0.;
	float tw = 0.;
	for (int i = 0; i < BACK_LAYER_QUALITY; ++i) {
		float mag = dot(p, p);
		p = abs(p) / mag + vec3(-.5, -.4, -1.5);
		float w = exp(-float(i) / 7.);
		accum += w * exp(-strength * pow(abs(mag - prev), 2.2));
		tw += w;
		prev = mag;
	}
	return max(0., 5. * accum / tw - .7);
}

vec3 nrand3(vec2 co)
{
	vec3 a = fract(cos(co.x*8.3e-3 + co.y)*vec3(1.3e5, 4.7e5, 2.9e5));
	vec3 b = fract(sin(co.x*0.3e-3 + co.y)*vec3(8.1e5, 1.0e5, 0.1e5));
	vec3 c = mix(a, b, 0.5);
	return c;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
	vec2 uv = 2. * gl_FragCoord.xy / love_ScreenSize.xy - 1.;
	vec2 uvs = uv * love_ScreenSize.xy / max(love_ScreenSize.x, love_ScreenSize.y);
	vec3 p = vec3(uvs / 4., 0) + vec3(1., -1.3, 0.);
#ifdef EVOLVE
	p += .2 * vec3(offset,  sin(global_time / 128.));
#else
	p += vec3(offset, 0);
#endif
	float t = field(p,freqs[2]);
	float v = 1;
	
	//Second Layer
	vec3 p2 = vec3(uvs / (4.+sin(global_time*0.11)*0.2+0.2+sin(global_time*0.15)*0.3+0.4), 1.5) + vec3(2., -1.3, -1.);
#ifdef EVOLVE
	p2 += 0.25 * vec3(0, 0,  sin(global_time / 128.));
#endif
	p2 += 0.2*p;

	float t2 = field2(p2,freqs[3]);
	vec4 c2 = mix(.4, 1., v) * vec4(1.3 * t2 * t2 * t2 ,1.8  * t2 * t2 , t2* freqs[0], t2);
	
	
	//Let's add some stars
	vec2 seed = p.xy * 2.0;	
	seed = floor(seed * love_ScreenSize.x);
	vec3 rnd = nrand3(seed);
	vec4 starcolor = vec4(pow(rnd.y,40.0));
	
	//Second Layer
	vec2 seed2 = p2.xy * 2.0;
	seed2 = floor(seed2 * love_ScreenSize.x);
	vec3 rnd2 = nrand3(seed2);
	starcolor += vec4(pow(rnd2.y,40.0));
	
	return mix(freqs[3]-.3, 1., v) * vec4(1.5*freqs[2] * t * t* t , 1.2*freqs[1] * t * t, freqs[3]*t, 1.0)+c2+starcolor;
}
