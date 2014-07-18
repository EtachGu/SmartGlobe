//
//  LabelsData.h
//  SmartGlobe
//
//  Created by G on 4/23/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#ifndef __SmartGlobe__LabelsData__
#define __SmartGlobe__LabelsData__
#include "Mark.hpp"
#include <iostream>
#include <vector.h>
using namespace std;
class LabelsData :public MarkUserData
{
public:
    LabelsData()
    {
        _content = "\0";
    }
    ~LabelsData(){}
    void addImage(const string& name);
    int getImagesCount();
    void  setContent(const string& content)
    {
        _content = content;
    }

// member
    vector<string> _images;
    string              _content;
};


#endif /* defined(__SmartGlobe__LabelsData__) */
