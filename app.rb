#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require 'bundler/setup'
require 'sinatra'
require 'haml'
require 'json'
require 'RMagick'


get '/' do
  haml :index
end


get '/images/:name' do
  send_file "images/" + params[:name]
end


post '/convert' do
  if params.empty? || params[:upfile].empty?
    halt 500, "File is empty."
  end
  if request.content_length.to_i > 1024 * 1000
    halt 500, "Capacity over."
  end

  file = params[:upfile]
  halt 500, "Unsupport format." unless "image/gif" == file[:type]

  filename = "images/temp-#{Time.now.to_i}.gif"
  open(filename, "w"){|f| f.write file[:tempfile].read}
  list = Magick::ImageList.new(filename)

  outputs = "images/tabnimation-#{Time.now.to_i}"
  list.write(outputs + ".png")

  @filename = outputs
  @slidesize = list.size
  haml :convert
end


template :index do
  <<-EOF
!!!
%html
  %head
    %title= "Tabnimation"
  %body
    %h3 UPLOAD
    %form#upload-form{:action => "/convert", :method => "post", :enctype => 'multipart/form-data'}
      %input{:type => "file", :name => "upfile"}
      %input{:type => "submit"}
EOF
end


template :convert do
  <<-EOF
!!!
%html
  %head
    %title= "Tabnimation"
    %script{:type => "text/javascript", :src => "https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"}
    %script{:type => "text/javascript", :src => "js/tabnimation.js"}
  %body
    %input{:type => "hidden", :name => "slidesize", :value => @slidesize}
    %input{:type => "hidden", :name => "filename", :value => @filename}
    %input#open-tab{:type => "button", :value => "Open Tab"}

EOF
end
