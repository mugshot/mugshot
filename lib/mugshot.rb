# -*- encoding: utf-8 -*-
require "active_support/core_ext"

module Mugshot
  autoload :Image, "mugshot/image"
  autoload :Storage, "mugshot/storage"
  autoload :FSStorage, "mugshot/fs_storage"
  autoload :Application, "mugshot/application"
  autoload :HTTPStorage, "mugshot/http_storage"
  autoload :MagickFactory, "mugshot/magick_factory"
end
