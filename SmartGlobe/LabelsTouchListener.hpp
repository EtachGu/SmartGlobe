//
//  LabelsTouchListener.h
//  SmartGlobe
//
//  Created by G on 4/22/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#ifndef __SmartGlobe__LabelsTouchListener__
#define __SmartGlobe__LabelsTouchListener__
#include "MarkTouchListener.hpp"
#include "Mark.hpp"
#include "LabelInfoView.hpp"
#include <iostream>
#include <Foundation/Foundation.h>

class LabelsTouchListener : public MarkTouchListener {
private:
    UIView*   _rootView;
    UIView*   _markView;
    int          _backgroundImageIndex;
    Mark*      _mark;
public:
    LabelsTouchListener(UIView * view)
    {
        _rootView = view;
        _markView = NULL;
    }
    void clear()
    {
            if(_markView)
            {
                [_markView removeFromSuperview];
            }
    }
    bool createDiagramView(Mark* mark ,const Vector2F pixels);
    bool touchedMark(Mark* mark)
    {
        NSString* message = [NSString stringWithFormat: @"Touched on mark \"%s\"", mark->getLabel().c_str()];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Glob3 Demo"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        
        
        
        return true;
    }
    bool touchedMark(Mark* mark ,const Vector2F pixels)
    {
               return createDiagramView(mark, pixels);
    }
    CGRect  getCGRect(const Vector2F pixels);
};

#endif /* defined(__SmartGlobe__LabelsTouchListener__) */
