%module govalhalla
%include <std_string.i>
%include <std_pair.i>


%{
#include <valhalla/tyr/actor.h>
#include <valhalla/baldr/graphreader.h>
#include <valhalla/baldr/rapidjson_utils.h>
#include <valhalla/proto/api.pb.h>
#include <valhalla/baldr/location.h>
#include <valhalla/sif/costfactory.h>
#include <valhalla/thor/pathinfo.h>
#include <valhalla/thor/route_matcher.h>
#include <valhalla/midgard/util.h>
#include <boost/property_tree/ptree.hpp>
#include <string>
#include <memory>
#include <functional>

using namespace valhalla;
using namespace valhalla::baldr;
using namespace valhalla::tyr;

%}


// %ignore tile_extract_t;
// %ignore SearchFilter;
// %ignore rapidjson::get_optional;
// %ignore std::hash<valhalla::baldr::Location>;

// Expose std::pair<std::string, std::string> to hold the result 

typedef std::pair<std::string, std::string> ResponsePair;

%template(ResponsePair) std::pair<std::string, std::string>;

// %typemap(in) const std::function<void()>* {
//     $1 = nullptr;
// }


// Expose the ActorWrapper class to Go
// %typemap(gotype) std::uintptr_t "uintptr"   // Map to Go's uintptr type
// %typemap(in) std::uintptr_t {
//     $1 = static_cast<std::uintptr_t>($input);
// }
// %typemap(out) std::uintptr_t {
//     $result = static_cast<std::uintptr_t>($1);
// }

// %include "valhalla/proto/api.pb.h"
// Declare the namespaces and class before extending
// Include necessary headers for SWIG parsing
// %import <valhalla/proto/api.pb.h>
// %import <valhalla/baldr/graphreader.h>
// %include <boost/property_tree/ptree.hpp>
namespace valhalla {
namespace tyr {
class actor_t {
// public:
    
private:
    actor_t(const boost::property_tree::ptree& config, bool auto_cleanup = false);
    actor_t(const boost::property_tree::ptree& config, valhalla::baldr::GraphReader& reader, bool auto_cleanup = false);
    ~actor_t();
    actor_t() = delete;  // Prevent default constructor
};
}}


%extend valhalla::tyr::actor_t {

      static actor_t* CreateActor(const std::string& config_json, bool auto_cleanup = false) {
        actor_t* actor = nullptr;
        std::string err = "";
        
        try {

            boost::property_tree::ptree pt;
            std::istringstream is(config_json);
            rapidjson::read_json(is, pt);
            
            actor = new actor_t(pt, auto_cleanup);
            // Test the actor
            // actor->status("");
            
            // auto* wrapper = new ActorWrapper(actor);
            // handle = reinterpret_cast<std::uintptr_t>(actor);
        } catch (const std::exception& e) {
            // return std::make_pair("", std::string("Error: ") + e.what());
            return nullptr;
        } catch (...) {
            // return std::make_pair("", "Unknown error");
            return nullptr;
        }
        
        return actor;
    }
    
    // Direct method signatures matching Valhalla's actor

    std::pair<std::string, std::string> Act( valhalla::Api& api, const std::function<void()>* interrupt = nullptr) {
        
        
        try {

            return std::make_pair(self->act(api, interrupt), "");
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }

     std::pair<std::string, std::string> Route(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->route(request, interrupt, api), "");
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }

     std::pair<std::string, std::string> Matrix(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->matrix(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }

    std::pair<std::string, std::string> OptimizedRroute(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->optimized_route(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }

    std::pair<std::string, std::string> Isochrone(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->isochrone(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }


    std::pair<std::string, std::string> TraceRoute(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->trace_route(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }


    std::pair<std::string, std::string> TraceAttributes(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->trace_attributes(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }


    std::pair<std::string, std::string> Height(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->height(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }


    std::pair<std::string, std::string> TransitAvailable(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->transit_available(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }


    std::pair<std::string, std::string> Expansion(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->expansion(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }


    std::pair<std::string, std::string> Centroid(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->centroid(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }


    std::pair<std::string, std::string> Status(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        
        
        try {

            return std::make_pair(self->status(request, interrupt, api), "");
            
            
        } catch (const std::exception& e) {
            return std::make_pair("", std::string("Error: ") + e.what());
        } catch (...) {
            return std::make_pair("", "Unknown error");
        }
        
        
    }

    
    void Cleanup() {
        if (self) {
            self->cleanup();
        }
    }

// private:
//     explicit ActorWrapper(valhalla::tyr::actor_t* actor) : actor_(actor) {}
    
//     ~ActorWrapper() {
//         if (actor_) {
//             try {

//                 actor_->cleanup();
//             } catch (...) {
//                 //  cleanup errors
//             }
//             delete actor_;
//         }
//     }
    
//     // Prevent copying
//     ActorWrapper(const ActorWrapper&) = delete;
//     ActorWrapper& operator=(const ActorWrapper&) = delete;
};


// CGO preamble
%insert(go_begin) %{
/*
// #cgo CXXFLAGS: -std=c++17 -I./result/include
#cgo LDFLAGS: -L${SRCDIR}/result/lib  -lgovalhalla
*/
%}
