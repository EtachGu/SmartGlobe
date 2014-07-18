//
//  Header.h
//  G3MiOSDemo
//
//  Created by G on 3/20/14.
//
//

#ifndef G3MiOSDemo_AnimateHUDWidgetsTask_h
#define G3MiOSDemo_AnimateHUDWidgetsTask_h


#include "GTask.hpp"
#include "HUDQuadWidget.hpp"
#include "LabelImageBuilder.hpp"
#include "Camera.hpp"
#include "Geodetic3D.hpp"
#include "G3MBuilder_iOS.hpp"
#include "G3MWidget.hpp"

class AnimateHUDWidgetsTask : public GTask {
private:
    HUDQuadWidget*     _compass1;
    HUDQuadWidget*     _compass2;
    HUDQuadWidget*     _ruler;
    LabelImageBuilder*   _labelBuilder;
    const Planet *                   _planet;
    G3MWidget*             _widget;
    
    double _angleInRadians;
    
    float _translationV;
    float _translationStep;
    bool   _printDegree;
public:
    AnimateHUDWidgetsTask(HUDQuadWidget* compass1,
                          HUDQuadWidget* compass2,
                          HUDQuadWidget* ruler,
                          LabelImageBuilder* labelBuilder) :
    _compass1(compass1),
    _compass2(compass2),
    _ruler(ruler),
    _labelBuilder(labelBuilder),
    _angleInRadians(0),
    _translationV(0),
    _translationStep(0.002),
    _printDegree(true)
    {
    }
    AnimateHUDWidgetsTask(HUDQuadWidget* compass1,
                          HUDQuadWidget* compass2,
                          LabelImageBuilder* labelBuilder,
                          G3MWidget*  widget,
                         const Planet* planet) :
    _compass1(compass1),
    _compass2(compass2),
    _labelBuilder(labelBuilder),
    _widget(widget),
    _planet(planet),
    _angleInRadians(0),
    _translationV(0),
    _translationStep(0.002),
     _printDegree(true)
    {
    }

    
    void run(const G3MContext* context)
    {
      
        G3MWidget  * widget = _widget;
        if(widget ==NULL )
        {
            return ;
        }
        
        // get camera info
        const  Camera*   currentCamera = widget->getCurrentCamera();
        const Geodetic3D pos =  currentCamera->getGeodeticPosition();
//        const std::string longitude = "lon:" +  IStringUtils::instance()->toString( pos._longitude._degrees);
//        const std::string latitude = "lat:"+  IStringUtils::instance()->toString( pos._latitude._degrees);
//        const std::string height   = "height: " + IStringUtils::instance()->toString(pos._height) + "米";
//        const std::string cameraInfoText =longitude +" , " + latitude +" , " +height;
//        _labelBuilder->setText( cameraInfoText );
        if (_printDegree)
        {
            printDegrees(pos);
        }
        else
        {
            printSpirteDegree(pos);
        }
        
        //update the North Compass orientation
//       const  Planet* planet = _builder->getPlanet();
//        planet ->
//
       Angle head = currentCamera ->getHeading();
       _compass2->setTexCoordsRotation(-head._radians, 0.5, 0.5);
        
        
        
    }
    std::string getstring(const std::string& s,int num)
    {
        int dot = s.find(".");
        int n    = s.length();
        std::string longitude1;
        if(dot >0 && (n-dot) >num)
        {
            longitude1 = s.substr(0,dot+ num);
        }
        return longitude1;
    }
    
    void printDegrees(const Geodetic3D& pos)
    {
        const std::string longitude = IStringUtils::instance()->toString( pos._longitude._degrees);
//        int dot = longitude.find(".");
//        int n    = longitude.length();
//        if(n-dot >6)
//        {
//           std::string longitude1 = longitude.substr(0,dot+ 6);
//        }
        const std::string longitude1=getstring(longitude, 6);
        
        const std::string latitude = IStringUtils::instance()->toString( pos._latitude._degrees);
        const std::string latitude1=getstring(latitude, 6);
        const std::string height   = IStringUtils::instance()->toString(pos._height) ;
       const std::string height1=getstring(height, 2);
        const std::string cameraInfoText ="lon:" +  longitude1 +" , " + "lat:"+  latitude1 +" , " +"height: " + height1+ "米";
        _labelBuilder->setText( cameraInfoText );
    }
    //按度分秒输出
    void printSpirteDegree(const Geodetic3D& pos)
    {
        double longitude_ =pos._longitude._degrees;
        int  longitude_d  = (int)  IMathUtils::instance()->floor(longitude_);
        longitude_  =        (longitude_-longitude_d) * 60.0;
        int  longitude_m  =(int)  IMathUtils::instance()->floor(longitude_);
         longitude_  =        (longitude_-longitude_m) * 60.0;
        int  longitude_s   = (int)  IMathUtils::instance()->floor(longitude_);
        
        const std::string longitude = "lon:" +  IStringUtils::instance()->toString( longitude_d)+"°"
                                                            +  IStringUtils::instance()->toString( longitude_m)+"′"
                                                            +  IStringUtils::instance()->toString( longitude_s)+"″";
        
        double latitude_ =pos._latitude._degrees;
        int  latitude_d  = (int)  IMathUtils::instance()->floor(latitude_);
        latitude_  =        (latitude_-latitude_d) * 60.0;
        int  latitude_m  =(int)  IMathUtils::instance()->floor(latitude_);
        latitude_  =        (latitude_-latitude_m) * 60.0;
        int  latitude_s   = (int)  IMathUtils::instance()->floor(latitude_);
        const std::string latitude = "lat:" +  IStringUtils::instance()->toString( latitude_d)+"°"
                                                         +      IStringUtils::instance()->toString( latitude_m)+"′"
                                                         +      IStringUtils::instance()->toString( latitude_s)+"″";
        
        
        const std::string height   = IStringUtils::instance()->toString(pos._height) ;
        const std::string height1= getstring(height, 2);
        const std::string cameraInfoText =longitude +" , " + latitude +" , " +"height: " +height1+ "米";
        _labelBuilder->setText( cameraInfoText );
    }
    void setPrintMethod(bool degree)
    {
        _printDegree=degree;
    }
    bool isPrintDegree()
    {
        return _printDegree;
    }
};



#endif
