////
////  CCView.m
////  LHPageView
////
////  Created by bangong on 17/3/7.
////  Copyright © 2017年 auto. All rights reserved.
////
//

#import "CCView.h"
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

typedef struct {
    float Position[3];
    float Color[4];
} Vertex;

const Vertex Vertices[] = {
    {{1, -1, 0}, {1, 0, 0, 1}},
    {{1, 1, 0}, {0, 1, 0, 1}},
    {{-1, 1, 0}, {0, 0, 1, 1}},
    {{-1, -1, 0}, {0, 0, 0, 1}}
};

const GLubyte Indices[] = {
    0, 1, 2,
    2, 3, 0
};

//GLuint _projectionUniform = glGetUniformLocation(programHandle, "Projection");

// Add to render, right before the call to glViewport
//CC3GLMatrix *projection = [CC3GLMatrix matrix];
//float h =4.0f* self.frame.size.height / self.frame.size.width;
//[projection populateFromFrustumLeft:-2 andRight:2 andBottom:-h/2 andTop:h/2 andNear:4 andFar:10];
//glUniformMatrix4fv(_projectionUniform, 1, 0, projection.glMatrix);
//
//// Modify vertices so they are within projection near/far planes
//const Vertex Vertices[] = {
//    {{1, -1, -7}, {1, 0, 0, 1}},
//    {{1, 1, -7}, {0, 1, 0, 1}},
//    {{-1, 1, -7}, {0, 0, 1, 1}},
//    {{-1, -1, -7}, {0, 0, 0, 1}}
//};

@implementation CCView
{
    EAGLContext *_eaglContext;
    CAEAGLLayer *_eaglLayer;
    GLuint _positionSlot;
    GLuint _colorSlot;

}

+ (Class)layerClass{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _eaglLayer = (CAEAGLLayer *)self.layer;
        _eaglLayer.opaque = YES;
       // _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];

       _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        [EAGLContext setCurrentContext:_eaglContext];


        GLuint _colorRenderBuffer;
        glGenRenderbuffers(1, &_colorRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
        [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];

        GLuint framebuffer;
        glGenFramebuffers(1, &framebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                                  GL_RENDERBUFFER, _colorRenderBuffer);



        [self compileShaders];
        [self setupVBOs];
        [self render];


    }
    return self;
}

- (void)render {
    glClearColor(0.0, 0.4f, 0.6f, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    bool yes = true;
    if (yes) {
        // 1
        glViewport(0, 0, self.frame.size.width, self.frame.size.height);

        // 2
        glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), 0);
        glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE,
                              sizeof(Vertex), (GLvoid*) (sizeof(float) *3));

        // 3
        glDrawElements(GL_TRIANGLES, sizeof(Indices)/sizeof(Indices[0]),
                       GL_UNSIGNED_BYTE, 0);

    }
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupVBOs {

    GLuint vertexBuffer;
    glGenBuffers(1, &vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertices), Vertices, GL_STATIC_DRAW);

    GLuint indexBuffer;
    glGenBuffers(1, &indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(Indices), Indices, GL_STATIC_DRAW);
    
}

- (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {

    // 1
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }

    // 2
    GLuint shaderHandle = glCreateShader(shaderType);

    // 3
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = [shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);

    // 4
    glCompileShader(shaderHandle);

    // 5
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    
    return shaderHandle;
}


- (void)compileShaders {

    // 1
    GLuint vertexShader = [self compileShader:@"SimpleVertex"
                                     withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"SimpleFragment"
                                       withType:GL_FRAGMENT_SHADER];

    // 2
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, fragmentShader);
    glLinkProgram(programHandle);

    // 3
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }

    // 4
    glUseProgram(programHandle);

    // 5
    _positionSlot = glGetAttribLocation(programHandle, "Position");
    _colorSlot = glGetAttribLocation(programHandle, "SourceColor");
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
}

@end
