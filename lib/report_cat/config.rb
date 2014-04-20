require 'singleton'

module ReportCat

  class Config
    include Singleton

    NIL_PROC = proc {}

    attr_accessor :authenticate, :authorize
    attr_accessor :layout

    def authenticate_with(&blk)
      @authenticate = blk if blk
      @authenticate || NIL_PROC
    end

    def authorize_with(&block)
      @authorize = block if block
      @authorize || NIL_PROC
    end

  end

end