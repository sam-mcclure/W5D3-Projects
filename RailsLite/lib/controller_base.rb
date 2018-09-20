require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'

class ControllerBase
  #All Your ControllerBase are belong to us
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise "Error" if already_built_response?
    @res.status = 302
    @res['Location'] = url
    @already_built_response = true
    session.store_session(@res)
    nil
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  #[]= Header Setter
  #Not one of these: <header> metadata </header>
  #but one of these : Content-Type, Content-Length, etc
  def render_content(content, content_type)
    raise "Error" if already_built_response?
    @res.write(content)
    @res['Content-Type'] = content_type
    @already_built_response = true
    session.store_session(@res)
    nil
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    raise "Generical Error" if already_built_response?
    dir_path = File.dirname(__FILE__)
    template_path = File.join(dir_path, "..", "views","#{self.class.name.underscore}","#{template_name}.html.erb")
    # template_path.gsub("lib/", "")
    template_code = File.read(template_path)
    render_content(ERB.new(template_code).result(binding), "text/html")
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(@req)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end
