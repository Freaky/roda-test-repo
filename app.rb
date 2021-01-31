#!/usr/bin/env ruby
# frozen_string_literal: true

require 'roda'
require 'concurrent'

class App < Roda
  plugin :render
  plugin :partials, views: 'templates'

  route do |r|
    r.root do
      Array.new(50).map do |x|
        Concurrent::Promises.future do
          partial 'expensive', locals: { x: rand(1..50) }
        end
      end.map(&:value!).join
    end
  end
end

