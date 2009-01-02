
#include "ruby.h"
#include "FreeImage.h"

      #define GET_BITMAP(name) FIBITMAP *(name); Data_Get_Struct(self, FIBITMAP, (name)); if (!(name)) rb_raise(rb_eTypeError, "Bitmap has already been freed")


      VALUE unload(VALUE self) {
        GET_BITMAP(bitmap);

        FreeImage_Unload(bitmap);
        DATA_PTR(self) = NULL;
        return Qnil;
      }


      VALUE wrap_and_yield(FIBITMAP *image, VALUE self, FREE_IMAGE_FORMAT fif) {
        VALUE klass = fif ? self         : CLASS_OF(self);
        VALUE type  = fif ? INT2FIX(fif) : rb_iv_get(self, "@file_type");
        VALUE obj = Data_Wrap_Struct(klass, NULL, NULL, image);
        rb_iv_set(obj, "@file_type", type);
        return rb_ensure(rb_yield, obj, unload, obj);
      }


      void copy_icc_profile(VALUE self, FIBITMAP *from, FIBITMAP *to) {
        FREE_IMAGE_FORMAT fif = FIX2INT(rb_iv_get(self, "@file_type"));
        if (fif != FIF_PNG && FreeImage_FIFSupportsICCProfiles(fif)) {
          FIICCPROFILE *profile = FreeImage_GetICCProfile(from);
          if (profile && profile->data) { 
            FreeImage_CreateICCProfile(to, profile->data, profile->size); 
          }
        }
      }


      void FreeImageErrorHandler(FREE_IMAGE_FORMAT fif, const char *message) {
        if (! RTEST(ruby_debug)) return;
        rb_raise(rb_eRuntimeError,
                 "FreeImage exception for type %s: %s",
                  (fif == FIF_UNKNOWN) ? "???" : FreeImage_GetFormatFromFIF(fif),
                  message);
      }


# line 143 "/Applications/Locomotive2/Bundles/standardRailsMar2007.locobundle/powerpc/lib/ruby/gems/1.8/gems/image_science-1.1.3/lib/image_science.rb"
static VALUE with_image(VALUE self, VALUE _input) {
  char * input = STR2CSTR(_input);

        FREE_IMAGE_FORMAT fif = FIF_UNKNOWN; 

        fif = FreeImage_GetFileType(input, 0); 
        if (fif == FIF_UNKNOWN) fif = FreeImage_GetFIFFromFilename(input); 
        if ((fif != FIF_UNKNOWN) && FreeImage_FIFSupportsReading(fif)) { 
          FIBITMAP *bitmap;
          VALUE result = Qnil;
          int flags = fif == FIF_JPEG ? JPEG_ACCURATE : 0;
          if (bitmap = FreeImage_Load(fif, input, flags)) {
            result = wrap_and_yield(bitmap, self, fif);
          }
          return (result);
        }
        rb_raise(rb_eTypeError, "Unknown file format");
      }


# line 162 "/Applications/Locomotive2/Bundles/standardRailsMar2007.locobundle/powerpc/lib/ruby/gems/1.8/gems/image_science-1.1.3/lib/image_science.rb"
static VALUE with_crop(VALUE self, VALUE _l, VALUE _t, VALUE _r, VALUE _b) {
  int l = FIX2INT(_l);
  int t = FIX2INT(_t);
  int r = FIX2INT(_r);
  int b = FIX2INT(_b);

        FIBITMAP *copy;
        VALUE result = Qnil;
        GET_BITMAP(bitmap);

        if (copy = FreeImage_Copy(bitmap, l, t, r, b)) {
          copy_icc_profile(self, bitmap, copy);
          result = wrap_and_yield(copy, self, 0);
        }
        return (result);
      }


# line 176 "/Applications/Locomotive2/Bundles/standardRailsMar2007.locobundle/powerpc/lib/ruby/gems/1.8/gems/image_science-1.1.3/lib/image_science.rb"
static VALUE height(VALUE self) {

        GET_BITMAP(bitmap);

        return INT2FIX(FreeImage_GetHeight(bitmap));
      }


# line 184 "/Applications/Locomotive2/Bundles/standardRailsMar2007.locobundle/powerpc/lib/ruby/gems/1.8/gems/image_science-1.1.3/lib/image_science.rb"
static VALUE width(VALUE self) {

        GET_BITMAP(bitmap);

        return INT2FIX(FreeImage_GetWidth(bitmap));
      }


# line 192 "/Applications/Locomotive2/Bundles/standardRailsMar2007.locobundle/powerpc/lib/ruby/gems/1.8/gems/image_science-1.1.3/lib/image_science.rb"
static VALUE resize(VALUE self, VALUE _w, VALUE _h) {
  long w = NUM2INT(_w);
  long h = NUM2INT(_h);

        if (w <= 0) rb_raise(rb_eArgError, "Width <= 0");
        if (h <= 0) rb_raise(rb_eArgError, "Height <= 0");
        GET_BITMAP(bitmap);
        FIBITMAP *image = FreeImage_Rescale(bitmap, w, h, FILTER_CATMULLROM);
        if (image) {
          copy_icc_profile(self, bitmap, image);
          return (wrap_and_yield(image, self, 0));
        }
        return (Qnil);
      }


# line 206 "/Applications/Locomotive2/Bundles/standardRailsMar2007.locobundle/powerpc/lib/ruby/gems/1.8/gems/image_science-1.1.3/lib/image_science.rb"
static VALUE save(VALUE self, VALUE _output) {
  char * output = STR2CSTR(_output);

        FREE_IMAGE_FORMAT fif = FreeImage_GetFIFFromFilename(output);
        if (fif == FIF_UNKNOWN) fif = FIX2INT(rb_iv_get(self, "@file_type"));
        if ((fif != FIF_UNKNOWN) && FreeImage_FIFSupportsWriting(fif)) { 
          GET_BITMAP(bitmap);
          int flags = fif == FIF_JPEG ? JPEG_QUALITYSUPERB : 0;
          if (fif == FIF_PNG) FreeImage_DestroyICCProfile(bitmap);
          return (FreeImage_Save(fif, bitmap, output, flags) ? Qtrue : Qfalse);
        }
        rb_raise(rb_eTypeError, "Unknown file format");
      }


#ifdef __cplusplus
extern "C" {
#endif
  void Init_Inline_ImageScience_aa58() {
    VALUE c = rb_cObject;
    c = rb_const_get(c,rb_intern("ImageScience"));
    rb_define_method(c, "height", (VALUE(*)(ANYARGS))height, 0);
    rb_define_method(c, "resize", (VALUE(*)(ANYARGS))resize, 2);
    rb_define_method(c, "save", (VALUE(*)(ANYARGS))save, 1);
    rb_define_method(c, "width", (VALUE(*)(ANYARGS))width, 0);
    rb_define_method(c, "with_crop", (VALUE(*)(ANYARGS))with_crop, 4);
    rb_define_singleton_method(c, "with_image", (VALUE(*)(ANYARGS))with_image, 1);
FreeImage_SetOutputMessage(FreeImageErrorHandler);

  }
#ifdef __cplusplus
}
#endif

