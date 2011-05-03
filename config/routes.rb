# encoding: UTF-8

# Copyright 2011 innoQ Deutschland GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

Rails.application.routes.draw do
  available_locales = /#{Iqvoc::Concept.pref_labeling_languages.map(&:to_s).join('|')}/

  scope '(:lang)' do
    resources :collections
    match 'search(.:format)' => 'search_results#index', :as => 'search'
  end

  match 'schema(.:format)' => 'pages#schema', :as => 'schema'

  scope ':lang', :lang => available_locales do
    resource  :user_session
    resources :users

    resources :concepts

    resources :virtuoso_syncs, :only => [:new, :create]

    match "concepts/versions/:origin/branch(.:format)"      => "concepts/versions#branch",    :as => "concept_versions_branch"
    match "concepts/versions/:origin/merge(.:format)"       => "concepts/versions#merge",     :as => "concept_versions_merge"
    match "concepts/versions/:origin/lock(.:format)"        => "concepts/versions#lock",      :as => "concept_versions_lock"
    match "concepts/versions/:origin/unlock(.:format)"      => "concepts/versions#unlock",    :as => "concept_versions_unlock"
    match "concepts/versions/:origin/to_review(.:format)"   => "concepts/versions#to_review", :as => "concept_versions_to_review"
    match "concepts/versions/:origin/consistency_check(.:format)" => "concepts/versions#consistency_check", :as => "concept_versions_consistency_check"

    match 'alphabetical_concepts/:letter(.:format)'   => 'concepts/alphabetical#index', :as => 'alphabetical_concepts'
    match 'hierarchical_concepts(.:format)' => 'concepts/hierarchical#index', :as => 'hierarchical_concepts'

    match 'hierarchical_collections(.:format)' => 'collections/hierarchical#index', :as => 'hierarchical_collections'

    match 'about(.:format)'     => 'pages#about',          :as => 'about'
    match 'dashboard(.:format)' => 'dashboard#index',      :as => 'dashboard'

    # There must be on named route 'localized_root' in order for an unlocalized root call to work
    # See ApplicationController#unlocalized_root
    root :to => 'concepts/hierarchical#index', :as => 'localized_root'
  end

  root :to => 'application#unlocalized_root'

  match '/:id(.:format)' => 'rdf#show', :as => 'rdf'
end
