//
//  ZWMSBillElevationDataProvider.h
//  G3MiOSSDK
//
//  Created by G on 3/18/14.
//
//

#ifndef __G3MiOSSDK__ZWMSBillElevationDataProvider__
#define __G3MiOSSDK__ZWMSBillElevationDataProvider__

#include "ElevationDataProvider.hpp"
#include <stddef.h>

#include "Vector2I.hpp"
#include "URL.hpp"
#include "Sector.hpp"

class IDownloader;

class ZWMSBillElevationDataProvider : public ElevationDataProvider {
private:
    IDownloader*      _downloader;
    URL               _url;
    const std::string _layerName;
    Sector            _sector;
    const double      _deltaHeight;
    
public:
    ZWMSBillElevationDataProvider(const URL& url,
                                 const std::string& layerName,
                                 const Sector& sector,
                                 double deltaHeight) :
    _url(url),
    _sector(sector),
    _downloader(NULL),
    _layerName(layerName),
    _deltaHeight(deltaHeight)
    {
        
    }
    
    bool isReadyToRender(const G3MRenderContext* rc) {
        return true;
    }
    
    void initialize(const G3MContext* context);
    
    const long long requestElevationData(const Sector& sector,
                                         const Vector2I& extent,
                                         IElevationDataListener* listener,
                                         bool autodeleteListener);
    
    void cancelRequest(const long long requestId);
    
    std::vector<const Sector*> getSectors() const{
        std::vector<const Sector*> sectors;
        sectors.push_back(&_sector);
        return sectors;
    }
    
    const Vector2I getMinResolution() const{
        //    int WORKING_JM;
        return Vector2I::zero();
    }
    ElevationData*  getElevationData(int width,int height,double elevation,const Sector& sector);
    
};


#endif /* defined(__G3MiOSSDK__ZWMSBillElevationDataProvider__) */
