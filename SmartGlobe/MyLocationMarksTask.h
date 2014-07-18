//
//  Header.h
//  SmartGlobe
//
//  Created by G on 3/28/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#ifndef SmartGlobe_MyLocationMarksTask_h
#define SmartGlobe_MyLocationMarksTask_h

#include "GTask.hpp"
#include "Camera.hpp"
#include "Geodetic3D.hpp"
#include "G3MBuilder_iOS.hpp"
#include "G3MWidget.hpp"
#include "MyLocationButton.h"
#include "Mark.hpp"
#include "MarksRenderer.hpp"
//#include "Angle.hpp"
//#include "Geodetic3D.hpp"
#include "G3MWidget.hpp"
#include "Camera.hpp"
#include "TimeInterval.hpp"


class MyLocationMarksTask: public GTask
{
public:
    MyLocationMarksTask(MyLocationButton* button, MarksRenderer* render , G3MWidget* widget)
    {
        _mylocationButton = button;
        _markRenderer       = render;
        _mark                    =NULL;
        _lastPos                 = new Geodetic3D(Geodetic3D::zero());
        _widget = widget;
        _havedMark = false ;
       
    }

       ~MyLocationMarksTask()
    {
        
    }
    void setAnimatedCameraPosition(const TimeInterval& interval,
                                   const Geodetic3D& position)
    {
        const  Camera * curCamera = _widget ->getCurrentCamera();
        Vector3D height = curCamera->getViewDirection();
        
        //set camera position
        const Geodetic3D toPos     =  Geodetic3D(position._latitude, position._longitude, position._height +2000);
        _widget ->setAnimatedCameraPosition(interval, curCamera->getGeodeticPosition(),toPos, curCamera->getHeading(), Angle::fromDegrees(0), curCamera->getPitch(), Angle::fromDegrees(0));
    }
    void setMarkPos()
    {
        if (_mark!=NULL)
        {
            if (_lastPos==NULL)
            {
                _lastPos =new Geodetic3D(_mark->getPosition());
            }
        }
        else
        {
            double latitude =(double)_mylocationButton.latitude;
            double longitude =(double)_mylocationButton.longitude;
            const Geodetic3D position  = Geodetic3D(Angle::fromDegrees(latitude), Angle::fromDegrees(longitude), 10);
            _mark = new Mark("我所在位置",
                             URL("file:///mylocation-bluedot_small.png"),
                             position,
                             RELATIVE_TO_GROUND,
                             4.0e+07,
                             true);
             if(_lastPos)
            {
                delete _lastPos,_lastPos =NULL;
            }
            _lastPos =new Geodetic3D(position);
        }
    }
    void run(const G3MContext* context)
    {
        
        if (_mylocationButton.pressed && !_havedMark) {
        const  Planet * planet = context->getPlanet();
        
       //update the position of mark
       if(! _mylocationButton.changed)
       {
           if (_mark==NULL) {
               return;
           }
           setMarkPos();
        }
       else
       {
           if (_mark!=NULL)
           {
               _markRenderer ->removeMark(_mark);
               delete  _mark , _mark=NULL;
           }
           setMarkPos();
       }
            
        //add mark
        _markRenderer->addMark(_mark);
        _havedMark = true;
        
        //set camera position
        setAnimatedCameraPosition(TimeInterval::fromSeconds(6.0),*_lastPos);
       }
        else if(!_mylocationButton.pressed)
        {
            _markRenderer ->removeMark(_mark);
            _havedMark =false;
        }
        
    }
private:

    MyLocationButton*  _mylocationButton;
    MarksRenderer*       _markRenderer;
    Mark*                     _mark;
    mutable Geodetic3D  *           _lastPos;
    G3MWidget*           _widget;
    bool                        _havedMark;

};



#endif
