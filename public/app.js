import * as THREE from 'three'
import { EffectComposer } from 'EffectComposer'
import { ShaderPass } from 'ShaderPass'

document.addEventListener('DOMContentLoaded', init())

function init() {
    THREE.Cache.enabled = true
    const shadersLoader = new THREE.FileLoader()
    shadersLoader.setResponseType("text")
    shadersLoader.load(
        'shaders/VS.glsl',
    
        // onLoad callback
        function ( data ) {
            THREE.Cache.add("VS", data)
            loadFragmentShader()
        },
    
        // onProgress callback
        function ( xhr ) {},
    
        // onError callback
        function ( err ) {
            console.error( err )
        }
    )

    function loadFragmentShader()
    {
        shadersLoader.load(
            'shaders/FS.glsl',
        
            // onLoad callback
            function ( data ) {
                THREE.Cache.add("FS", data)
                animationInit()
            },
        
            // onProgress callback
            function ( xhr ) {},
        
            // onError callback
            function ( err ) {
                console.error( err )
            }
        )
    }


    let renderer, composer
    let VS = "", FS = ""
    let dotsCount = Math.trunc(Math.random() * 10 + 3)
    let dotsData = []
    let dotsColorsData = []
    
    function animationInit()
    {
        VS = THREE.Cache.get("VS")
        FS = THREE.Cache.get("FS")
        FS = FS.replace("const int dotsCount = uniform int;", `const int dotsCount = ${dotsCount};`)
        
        renderer = new THREE.WebGLRenderer({
            canvas: document.getElementById('threejs'),
            antialias: true
        })
        renderer.setSize(window.innerWidth, window.innerHeight)
        renderer.setPixelRatio(window.devicePixelRatio)
        renderer.setClearColor(0x202020)

        composer = new EffectComposer(renderer)
        composer.setSize(window.innerWidth, window.innerHeight)
        composer.setPixelRatio(window.devicePixelRatio)

        for (let i = 0; i < dotsCount; i++) {
            dotsData.push(new THREE.Vector2(Math.sin(2*Math.PI * i/dotsCount), Math.cos(2*Math.PI * i/dotsCount)))
            dotsColorsData.push(new THREE.Vector4(Math.random(), Math.random(), Math.random(), 1))
        }

        const shaderProgram = {
            uniforms: {
                time: {value: 0},
                aspect: {value: window.innerWidth/window.innerHeight},
                offset: {value: new THREE.Vector2(0, 0)},
                zoom: {value: 0.1},
                dots: {value: dotsData},
                dotsColors: {value: dotsColorsData},
                depth: {value: 10},
                t: {value: 0}
            },
            vertexShader: VS,
            fragmentShader: FS
        }
        const shaderPass = new ShaderPass(shaderProgram)
        composer.addPass(shaderPass)

        renderer.setAnimationLoop(animation)
    }

    function animation(time)
    {
        composer.passes[0].uniforms.time.value = time
        composer.passes[0].uniforms.zoom.value = 0.1 + 2 * (1 - Math.cos(time/20000))
        composer.passes[0].uniforms.t.value = 0.75 - Math.cos(time/20000) / 4
        composer.render()
    }



    window.addEventListener('resize', resize)

    function resize()
    {
        composer.passes[0].uniforms.XScale.value = window.innerWidth/window.innerHeight

        composer.setSize(window.innerWidth, window.innerHeight)
        composer.setPixelRatio(Math.min(window.devicePixelRatio, 2))

        renderer.setSize(window.innerWidth, window.innerHeight)
        renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
    }
}