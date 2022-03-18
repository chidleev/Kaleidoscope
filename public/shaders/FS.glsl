struct Point {
    int type;

    vec2 position;
    vec2 direction;

    float distance;
    float influence;

    bool mustBeCloser;

    vec4 color;
};

#define PI 3.14159265359

//set from app.js
const int pointsCount = uniform int;

uniform Point points[pointsCount];
uniform float time;
uniform int maxIterations;

varying vec2 pixelPosition;

vec2 rotate(vec2 v, float a);
float getDistance(int pointIndex);

void main()
{
    vec4 resultColor = vec4(0.);

    float criticalDistance[pointsCount];
    for (int i = 0; i < pointsCount; i++) {
        criticalDistance[i] = points[i].distance * points[i].influence;
    }

    bool haveOneTruePoint = true;
    int truePointsCount = 0;
    int iteration = 0;
    
    while (haveOneTruePoint && iteration < maxIterations) {
        haveOneTruePoint = false;
        for (int i = 0; i < pointsCount; i++) {
            if (getDistance(i) >= criticalDistance[i]) {
                if (!points[i].mustBeCloser) {
                    haveOneTruePoint = true;
                    truePointsCount++;
                    resultColor += points[i].color;
                }
                criticalDistance[i] += criticalDistance[i] * pow(points[i].influence, float(iteration + 1));
            }
            else {
                if (points[i].mustBeCloser) {
                    haveOneTruePoint = true;
                    truePointsCount++;
                    resultColor += points[i].color;
                }
                criticalDistance[i] -= criticalDistance[i] * pow(points[i].influence, float(iteration + 1));
            }
        }
        iteration++;
    }

    vec4 criterionMask = vec4(float(truePointsCount) / float(pointsCount * maxIterations));
    vec4 iterationMask = vec4(float(iteration) / float(maxIterations));
    resultColor /= float(truePointsCount);

    gl_FragColor = mix(resultColor, vec4(0.), criterionMask);
}

float getDistance(int pointIndex) {
    if (length(points[pointIndex].direction) > 0.) {
        if (points[pointIndex].type == 1) {
            vec2 A = points[pointIndex].position;
            vec2 B = points[pointIndex].position + normalize(points[pointIndex].direction);
            return ((B.y - A.y) * pixelPosition.x - (B.x - A.x) * pixelPosition.y + B.x * A.y - B.y * A.x) / distance(A, B);
        }

        if (points[pointIndex].type == 2) {
            vec2 N = normalize(points[pointIndex].direction);
            vec2 C = points[pointIndex].position - pixelPosition;
            return length(C - dot(C, N) * N);
        }
    }
    return distance(pixelPosition, points[pointIndex].position);
}

vec2 rotate(vec2 v, float a) {
	float s = sin(a);
	float c = cos(a);
	mat2 m = mat2(c, -s, s, c);
	return m * v;
}