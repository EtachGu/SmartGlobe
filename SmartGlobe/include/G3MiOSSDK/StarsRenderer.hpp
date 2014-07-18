//
//  StarsRenderer.h
//  G3MiOSSDK
//
//  Created by G on 4/10/14.
//
//

#ifndef __G3MiOSSDK__StarsRenderer__
#define __G3MiOSSDK__StarsRenderer__

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

class EllipsoidShape;
class TileRasterizer;




class StarsRenderer : public LeafRenderer,ChangedListener
{
    private:
         IImageBuilder* _imageBuilder;
   const  IImage*            _image;
        Mesh*                 _StarsMesh;
    std::string   _imageName;
    Planet*                   _StarsPlanet;
    Sphere*             _StarsSphere;
    
    SimpleTextureMapping*  _simpleTextureMapping;
    bool                   _enable;
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
        
    void createMesh(const G3MRenderContext* rc);
    public:
        StarsRenderer(IImageBuilder*    imageBuilder);
        
        ~StarsRenderer();
        
        void initialize(const G3MContext* context);
    
       void updateGLState(const G3MRenderContext* rc);
    
        void render(const G3MRenderContext* rc, GLState* glState);
    
        void onResizeViewportEvent(const G3MEventContext* ec,
                                   int width, int height) ;
    void   imageCreated(const IImage* image,
                 const std::string& imageName);
    void onImageBuildError(const std::string& error);
        RenderState getRenderState(const G3MRenderContext* rc);
        

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
            return  false;;
        }
    
        StarsRenderer* getStarsRenderer() {
            return this;
        }
    
};

#endif /* defined(__G3MiOSSDK__StarsRenderer__) */
