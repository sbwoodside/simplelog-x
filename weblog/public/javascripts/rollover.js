/*  
 * Unobtrusive image rollover with Prototype library, v1.0
 * 
 * Created by Herryanto Siatono
 * Copyright (c) 2007 Pluit Solutions <www.pluitsolutions.com>
 * 
 * This script is freely distributable under the terms of an MIT-style license.
/*------------------------------------------------------------------------------*/

var Rollover= Class.create();
Rollover.prototype = {
  // provide the container id containing image links to be rolled over.
  initialize: function(id, options) {
    this.id = id;
    this.images = {};
    this.setOptions(options);
    this.observeLinks();
  },
  
  setOptions: function(options) {
    this.options = {
      rolloverSuffix: 'over',
      selectedSuffix: 'sel',
      suffixSeperator: '_'
    };
    Object.extend(this.options, options || {});
  },

  observeLinks: function() {
    this.links = $$('#' + this.id + ' a');
    for (i=0; i<this.links.length; i++) {
      this.links[i].observe('mouseover', this.rolloverImage);
      this.links[i].observe('mouseout', this.rollbackImage);
    }
    
    images = $$('#' + this.id + ' img');
    for (i=0; i<images.length; i++) {
      imageId = images[i].id 
      if (!imageId) {
        imageId  = this.id + i;
        images[i].id = imageId;
      }
      
      this.images[imageId] = images[i].src;
      images[i].imageRollover = this;

      // preload rollover image
      (new Image()).src = this.parseRolloverImage(images[i]);
    }
  },
  
  rolloverImage: function(e) {
    image = Event.element(e);
    image.imageRollover.images[image.id] = image.src;
    image.src = image.imageRollover.parseRolloverImage(image);
  },

  rollbackImage: function(e) {
    image = Event.element(e);
    image.src = image.imageRollover.images[image.id];
  },
  
  parseRolloverImage: function(image) {
    ext = image.src.substr(image.src.lastIndexOf('.'));
    path = image.src.match(/(.*)\/(.*\.(png|gif|jpg))/)[1]
    filename = image.src.gsub(path, '')
    basename = this.parseBasename(filename);
    basename = this.parseBasename(basename, this.options.suffixSeperator + this.options.selectedSuffix);
    return path + basename + this.options.suffixSeperator + this.options.rolloverSuffix + ext;
  },
  
  parseBasename: function(name, seperator) {
    seperator = seperator || '.';
    found = name.lastIndexOf(seperator);
    if (found > 0) {
      return name.substr(0, found);
    } else {
      return name;
    }
  }
}
