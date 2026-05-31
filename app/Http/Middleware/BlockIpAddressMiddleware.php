<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use App\Models\Ipaddress;
use Illuminate\Support\Facades\DB;

class BlockIpAddressMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle(Request $request, Closure $next)
{
    try {
        // Wrap the DB call in a try-catch
        $ipaddress = DB::table('ipaddresses')->pluck('ipaddress');
        $iparrays = $ipaddress->toArray();
        $userip = $request->ip();

        if (in_array($userip, $iparrays)) {
             abort(403, "You are restricted to access the site.");
        }
    } catch (\Exception $e) {
        // If DB is down, Log the error and ALLOW the request to pass.
        // Better for the site to be open than for it to be 500-down.
        \Log::error('BlockIpMiddleware DB Error: ' . $e->getMessage());
    }

    return $next($request);
}
}
