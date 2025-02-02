%module govalhalla
%include <std_string.i>
%include <std_pair.i>

%{
#include <valhalla/tyr/actor.h>
#include <valhalla/baldr/graphreader.h>
#include <valhalla/baldr/rapidjson_utils.h>
#include <valhalla/proto/api.pb.h>
#include <string>
#include <memory>
#include <functional>

using namespace valhalla;
using namespace valhalla::baldr;
using namespace valhalla::tyr;

%}


// Expose std::pair<std::string, std::string> to hold the result 

typedef std::pair<std::string, std::string> ResponsePair;

%template(ResponsePair) std::pair<std::string, std::string>;


// Expose the ActorWrapper class to Go
%typemap(gotype) std::uintptr_t "uintptr"   // Map to Go's uintptr type
%typemap(in) std::uintptr_t {
    $1 = static_cast<std::uintptr_t>($input);
}
%typemap(out) std::uintptr_t {
    $result = static_cast<std::uintptr_t>($1);
}
// %include "valhalla/tyr/actor.h"


%inline %{

// RAII wrapper for actor
class ActorWrapper {
private:
    actor_t* actor_;
    
public:
    static std::uintptr_t NewActor(const std::string& config_json, bool auto_cleanup = false) {
        std::uintptr_t handle = 0;
        std::string err = "";
        
        try {
            boost::property_tree::ptree pt;
            std::istringstream is(config_json);
            rapidjson::read_json(is, pt);
            
            auto* actor = new actor_t(pt, auto_cleanup);
            // Test the actor
            // actor->status("");
            
            auto* wrapper = new ActorWrapper(actor);
            handle = reinterpret_cast<std::uintptr_t>(wrapper);
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return handle;
    }
    
    // Direct method signatures matching Valhalla's actor

    std::pair<std::string, std::string> Act( valhalla::Api& api, const std::function<void()>* interrupt = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->act(api);
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }

     std::pair<std::string, std::string> Route(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->route(request, interrupt, api);
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }

     std::pair<std::string, std::string> Matrix(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->matrix(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }

    std::pair<std::string, std::string> OptimizedRroute(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->optimized_route(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }

    std::pair<std::string, std::string> Isochrone(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->isochrone(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }


    std::pair<std::string, std::string> TraceRoute(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->trace_route(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }


    std::pair<std::string, std::string> TraceAttributes(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->trace_attributes(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }


    std::pair<std::string, std::string> Height(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->height(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }


    std::pair<std::string, std::string> TransitAvailable(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->transit_available(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }


    std::pair<std::string, std::string> Expansion(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->expansion(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }


    std::pair<std::string, std::string> Centroid(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->centroid(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }


    std::pair<std::string, std::string> Status(const std::string& request, const std::function<void()>* interrupt = nullptr, valhalla::Api* api = nullptr) {
        std::string result = "";
        std::string err = "";
        
        try {
            auto response = actor_->status(request, interrupt, api);
            
            result = std::string(response);
            err = "";
        } catch (const std::exception& e) {
            err = std::string("std exceptionError: ") + e.what();
        } catch (...) {
            err = std::string("unknown exceptionError: ");
        }
        
        return {result, err};
    }

    
    void Cleanup() {
        if (actor_) {
            actor_->cleanup();
        }
    }

private:
    explicit ActorWrapper(actor_t* actor) : actor_(actor) {}
    
    ~ActorWrapper() {
        if (actor_) {
            try {
                actor_->cleanup();
            } catch (...) {
                //  cleanup errors
            }
            delete actor_;
        }
    }
    
    // Prevent copying
    ActorWrapper(const ActorWrapper&) = delete;
    ActorWrapper& operator=(const ActorWrapper&) = delete;
};



%}
// The CGO preamble 
%insert(go_begin) %{
/*
#cgo LDFLAGS: -L. -lvalhalla_go
#include <stdlib.h>
#include <valhalla/tyr/actor.h>
*/
%}
