//
//  AtmosphereRenderer.h
//  G3MiOSSDK
//
//  Created by G on 4/15/14.
//
//

#ifndef __G3MiOSSDK__AtmosphereRenderer__
#define __G3MiOSSDK__AtmosphereRenderer__

#include "LeafRenderer.hpp"
#include <iostream>

class Tile;
class TileTessellator;
class TileTexturizer;

#include "IStringBuilder.hpp"
#include "Sector.hpp"
#include "Camera.hpp"
#include "Mesh.hpp"
#include "IImageBuilder.hpp"
#include "TexturesHandler.hpp"
#include "SphericalPlanet.hpp"
#include "Sphere.hpp"
#include "TextureMapping.hpp"
#include "DirectMesh.hpp"
#include "TexturedMesh.hpp"
#include "IndexedGeometryMesh.hpp"
#include "ChangedListener.hpp"





class AtmosphereRenderer : public LeafRenderer ,ChangedListener
{
private:
  
     Mesh*               _atmosphereMesh;
    Planet*              _atmospherePlanet;
    Sphere*             _atmosphere;     // the sphere  of  the camera
    bool                  _enable;
    double               _atmosphereHeight;
    double               _planetRadius;
    double               _atmosRadius;
    Vector3D*          _cameraPos;
    
    std::string   _imageName;
    IImageBuilder* _imageBuilder;
    const  IImage*            _image;
    SimpleTextureMapping*  _simpleTextureMapping;
    bool         _buildingImage;
#ifdef C_CODE
    const Camera*     _lastCamera;
    const G3MContext* _context;
#endif
#ifdef JAVA_CODE
    private Camera     _lastCamera;
    private G3MContext _context;
#endif
    
    
    GLState* _glState;
    
    //  bool _validLayerTilesRenderParameters;
    std::vector<std::string> _errors;
    void  recreateMesh(const G3MRenderContext* rc);
    void createMesh(const G3MRenderContext* rc);
public:
    AtmosphereRenderer(const double atmosphereHeight,IImageBuilder*    imageBuilder);
    
    ~AtmosphereRenderer();
    
    void initialize(const G3MContext* context);
    
    void updateGLState(const G3MRenderContext* rc);
    
    void render(const G3MRenderContext* rc, GLState* glState);
    
    void onResizeViewportEvent(const G3MEventContext* ec,
                               int width, int height) ;
    void onImageBuildError(const std::string& error);
    RenderState getRenderState(const G3MRenderContext* rc);
    
    void imageCreated(const IImage *image, const std::string &imageName)
    {
        _buildingImage = false;
        _image = image;
        _imageName = imageName;
    }
    
    void start(const G3MRenderContext* rc) {
        
    }
    
    void stop(const G3MRenderContext* rc) {
        
    }
    
    void onResume(const G3MContext* context) {
        
    }
    
    void onPause(const G3MContext* context) {
        
    }
    
    void onDestroy(const G3MContext* context) {
        
    }
    
    void changed();
    
    void setEnable(bool enable)
    {
        _enable = enable;
    }
    bool onTouchEvent(const G3MEventContext* ec,
                      const TouchEvent* touchEvent){return false;}
    /**
     * @see Renderer#isPlanetRenderer()
     */
    bool isPlanetRenderer() {
        return  false;
    }
    
    AtmosphereRenderer* getAtmosphereRenderer() {
        return this;
    }
    
    bool isAvlidVertex(const Vector3D vertex);
    double getSmallValue(double n)
    {
        while (n>1) {
            n--;
        }
        return n;
    }
};
#endif /* defined(__G3MiOSSDK__AtmosphereRenderer__) */
