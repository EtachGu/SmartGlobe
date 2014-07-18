//
//  LabelsData.cpp
//  SmartGlobe
//
//  Created by G on 4/23/14.
//  Copyright (c) 2014 G. All rights reserved.
//

#include "LabelsData.h"
void LabelsData::addImage(const string& name)
{
    _images.push_back(name);
}
int LabelsData::getImagesCount()
{
   return  _images.size();
}
