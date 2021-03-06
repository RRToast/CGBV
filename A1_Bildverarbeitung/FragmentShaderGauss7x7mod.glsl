//
// Fragment Shader f�r 7x7 Gauss Tiefpassfilter
// Angepasst f�r Core Profile
// ---------------------------------
//
// @author: Prof. Dr. Alfred Nischwitz
// @lecturer: Prof. Dr. Alfred Nischwitz
//
// (c)2011 Hochschule M�nchen, HM
//
// ---------------------------------
#version 400

smooth in vec2 texCoords;			// pixelbezogene Texturkoordinate
out vec4 fragColor;					// Ausgabewert mit 4 Komponenten zwischen 0.0 und 1.0
uniform samplerRect textureMap;		// Sampler f�r die Texture Map
uniform vec4 param1;				// param1.x +=F5, -=F6, param1.y +=F7, -=F8, param1.z +=F9, -=F10, param1.w +=F11, -=F12

uniform float part = 0.05;
float pi = 3.14159265359;
float sigma = param1.w * part + 0.00000000001;
float twoTimeSquareSigma = 2 * sigma * sigma;
float twoTimePiSquareSigma = pi * twoTimeSquareSigma;

uniform vec2 offsets[7] = {	vec2(0,  -3),
							vec2(0,  -2),
							vec2(0,  -1),
							vec2(0,  0),
							vec2(0,  1),
							vec2(0,  2),
							vec2(0,  3) };

void main() {
	vec4 texel = vec4(0.0, 0.0, 0.0, 1.0);
	float sum = 0.0;
	float factors[7];

    for (int i = 0; i < offsets.length; i++) {
		float x = offsets[i].x;
		float y = offsets[i].y;		

		float ePower = exp(-(x * x + y * y) / twoTimeSquareSigma);		
		float factor = (1 / twoTimePiSquareSigma) * ePower;

		sum += factor;		
		factors[i] = factor;	
    }

	for (int i = 0; i < factors.length; i++) {
        texel += texture(textureMap, texCoords + offsets[i]) * factors.length / sum * factors[i];
	}
	   
	fragColor = texel / factors.length;
}