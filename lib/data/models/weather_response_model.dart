import 'dart:convert';

WeatherResponseModel weatherResponseModelFromJson(String str) => WeatherResponseModel.fromJson(json.decode(str));

String weatherResponseModelToJson(WeatherResponseModel data) => json.encode(data.toJson());

class WeatherResponseModel {
    final int queryCost;
    final double latitude;
    final double longitude;
    final String resolvedAddress;
    final String address;
    final String timezone;
    final double tzoffset;
    final String description;
    final List<CurrentConditions> days;
    final List<dynamic> alerts;
    final Map<String, Station> stations;
    final CurrentConditions currentConditions;

    WeatherResponseModel({
        required this.queryCost,
        required this.latitude,
        required this.longitude,
        required this.resolvedAddress,
        required this.address,
        required this.timezone,
        required this.tzoffset,
        required this.description,
        required this.days,
        required this.alerts,
        required this.stations,
        required this.currentConditions,
    });

    factory WeatherResponseModel.fromJson(Map<String, dynamic> json) => WeatherResponseModel(
        queryCost: json["queryCost"] ?? 0,
        latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
        longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
        resolvedAddress: json["resolvedAddress"] ?? "",
        address: json["address"] ?? "",
        timezone: json["timezone"] ?? "",
        tzoffset: (json["tzoffset"] as num?)?.toDouble() ?? 0.0,
        description: json["description"] ?? "",
        days: json["days"] == null
            ? []
            : List<CurrentConditions>.from(
            (json["days"] as List)
                .where((x) => x != null)
                .map((x) => CurrentConditions.fromJson(x))
        ),
        alerts: json["alerts"] == null ? [] : List<dynamic>.from(json["alerts"].map((x) => x)),
        stations: json["stations"] == null
            ? {}
            : Map.from(json["stations"]).map((k, v) => MapEntry<String, Station>(k, Station.fromJson(v))),
        currentConditions: json["currentConditions"] != null
            ? CurrentConditions.fromJson(json["currentConditions"])
            : CurrentConditions.empty(),
    );

    Map<String, dynamic> toJson() => {
        "queryCost": queryCost,
        "latitude": latitude,
        "longitude": longitude,
        "resolvedAddress": resolvedAddress,
        "address": address,
        "timezone": timezone,
        "tzoffset": tzoffset,
        "description": description,
        "days": List<dynamic>.from(days.map((x) => x.toJson())),
        "alerts": List<dynamic>.from(alerts.map((x) => x)),
        "stations": Map.from(stations).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
        "currentConditions": currentConditions.toJson(),
    };
}

class CurrentConditions {
    final String? datetime;
    final int? datetimeEpoch;
    final double? temp;
    final double? feelslike;
    final double? humidity;
    final double? dew;
    final double? precip;
    final double? precipprob;
    final double? snow;
    final double? snowdepth;
    final List<Preciptype>? preciptype;
    final double? windgust;
    final double? windspeed;
    final double? winddir;
    final double? pressure;
    final double? visibility;
    final double? cloudcover;
    final double? solarradiation;
    final double? solarenergy;
    final double? uvindex;
    final Conditions? conditions;
    final Icon? icon;
    final List<Id>? stations;
    final Source? source;
    final String? sunrise;
    final int? sunriseEpoch;
    final String? sunset;
    final int? sunsetEpoch;
    final double? moonphase;
    final double? tempmax;
    final double? tempmin;
    final double? feelslikemax;
    final double? feelslikemin;
    final double? precipcover;
    final double? severerisk;
    final String? description;
    final List<CurrentConditions>? hours;

    CurrentConditions({
        this.datetime,
        this.datetimeEpoch,
        this.temp,
        this.feelslike,
        this.humidity,
        this.dew,
        this.precip,
        this.precipprob,
        this.snow,
        this.snowdepth,
        this.preciptype,
        this.windgust,
        this.windspeed,
        this.winddir,
        this.pressure,
        this.visibility,
        this.cloudcover,
        this.solarradiation,
        this.solarenergy,
        this.uvindex,
        this.conditions,
        this.icon,
        this.stations,
        this.source,
        this.sunrise,
        this.sunriseEpoch,
        this.sunset,
        this.sunsetEpoch,
        this.moonphase,
        this.tempmax,
        this.tempmin,
        this.feelslikemax,
        this.feelslikemin,
        this.precipcover,
        this.severerisk,
        this.description,
        this.hours,
    });

    CurrentConditions.empty() :
            datetime = null,
            datetimeEpoch = null,
            temp = null,
            feelslike = null,
            humidity = null,
            dew = null,
            precip = null,
            precipprob = null,
            snow = null,
            snowdepth = null,
            preciptype = null,
            windgust = null,
            windspeed = null,
            winddir = null,
            pressure = null,
            visibility = null,
            cloudcover = null,
            solarradiation = null,
            solarenergy = null,
            uvindex = null,
            conditions = null,
            icon = null,
            stations = null,
            source = null,
            sunrise = null,
            sunriseEpoch = null,
            sunset = null,
            sunsetEpoch = null,
            moonphase = null,
            tempmax = null,
            tempmin = null,
            feelslikemax = null,
            feelslikemin = null,
            precipcover = null,
            severerisk = null,
            description = null,
            hours = null;

    // Dart
    factory CurrentConditions.fromJson(Map<String, dynamic> json) => CurrentConditions(
        datetime: json["datetime"],
        datetimeEpoch: json["datetimeEpoch"],
        temp: (json["temp"] as num?)?.toDouble(),
        feelslike: (json["feelslike"] as num?)?.toDouble(),
        humidity: (json["humidity"] as num?)?.toDouble(),
        dew: (json["dew"] as num?)?.toDouble(),
        precip: (json["precip"] as num?)?.toDouble(),
        precipprob: (json["precipprob"] as num?)?.toDouble(),
        snow: (json["snow"] as num?)?.toDouble(),
        snowdepth: (json["snowdepth"] as num?)?.toDouble(),
        preciptype: json["preciptype"] == null
            ? null
            : List<Preciptype>.from(
            (json["preciptype"] as List)
                .where((x) => x != null)
                .map((x) => preciptypeValues.map[x]!)
        ),
        windgust: (json["windgust"] as num?)?.toDouble(),
        windspeed: (json["windspeed"] as num?)?.toDouble(),
        winddir: (json["winddir"] as num?)?.toDouble(),
        pressure: (json["pressure"] as num?)?.toDouble(),
        visibility: (json["visibility"] as num?)?.toDouble(),
        cloudcover: (json["cloudcover"] as num?)?.toDouble(),
        solarradiation: (json["solarradiation"] as num?)?.toDouble(),
        solarenergy: (json["solarenergy"] as num?)?.toDouble(),
        uvindex: (json["uvindex"] as num?)?.toDouble(),
        conditions: json["conditions"] != null ? conditionsValues.map[json["conditions"]] : null,
        icon: json["icon"] != null ? iconValues.map[json["icon"]] : null,
        stations: json["stations"] == null
            ? null
            : List<Id>.from(
            (json["stations"] as List)
                .where((x) => x != null && idValues.map[x] != null)
                .map((x) => idValues.map[x]!)
        ),
        source: json["source"] != null ? sourceValues.map[json["source"]] : null,
        sunrise: json["sunrise"],
        sunriseEpoch: json["sunriseEpoch"],
        sunset: json["sunset"],
        sunsetEpoch: json["sunsetEpoch"],
        moonphase: (json["moonphase"] as num?)?.toDouble(),
        tempmax: (json["tempmax"] as num?)?.toDouble(),
        tempmin: (json["tempmin"] as num?)?.toDouble(),
        feelslikemax: (json["feelslikemax"] as num?)?.toDouble(),
        feelslikemin: (json["feelslikemin"] as num?)?.toDouble(),
        precipcover: (json["precipcover"] as num?)?.toDouble(),
        severerisk: (json["severerisk"] as num?)?.toDouble(),
        description: json["description"],
        hours: json["hours"] == null
            ? null
            : List<CurrentConditions>.from(
            (json["hours"] as List)
                .where((x) => x != null)
                .map((x) => CurrentConditions.fromJson(x))
        ),
    );

    Map<String, dynamic> toJson() => {
        "datetime": datetime,
        "datetimeEpoch": datetimeEpoch,
        "temp": temp,
        "feelslike": feelslike,
        "humidity": humidity,
        "dew": dew,
        "precip": precip,
        "precipprob": precipprob,
        "snow": snow,
        "snowdepth": snowdepth,
        "preciptype": preciptype == null ? [] : List<dynamic>.from(preciptype!.map((x) => preciptypeValues.reverse[x])),
        "windgust": windgust,
        "windspeed": windspeed,
        "winddir": winddir,
        "pressure": pressure,
        "visibility": visibility,
        "cloudcover": cloudcover,
        "solarradiation": solarradiation,
        "solarenergy": solarenergy,
        "uvindex": uvindex,
        "conditions": conditionsValues.reverse[conditions],
        "icon": iconValues.reverse[icon],
        "stations": stations == null ? [] : List<dynamic>.from(stations!.map((x) => idValues.reverse[x])),
        "source": sourceValues.reverse[source],
        "sunrise": sunrise,
        "sunriseEpoch": sunriseEpoch,
        "sunset": sunset,
        "sunsetEpoch": sunsetEpoch,
        "moonphase": moonphase,
        "tempmax": tempmax,
        "tempmin": tempmin,
        "feelslikemax": feelslikemax,
        "feelslikemin": feelslikemin,
        "precipcover": precipcover,
        "severerisk": severerisk,
        "description": description,
        "hours": hours == null ? [] : List<dynamic>.from(hours!.map((x) => x.toJson())),
    };
}

enum Conditions {
    CLEAR,
    OVERCAST,
    PARTIALLY_CLOUDY
}

final conditionsValues = EnumValues({
    "Clear": Conditions.CLEAR,
    "Overcast": Conditions.OVERCAST,
    "Partially cloudy": Conditions.PARTIALLY_CLOUDY
});

enum Icon {
    CLEAR_DAY,
    CLEAR_NIGHT,
    CLOUDY,
    PARTLY_CLOUDY_DAY,
    PARTLY_CLOUDY_NIGHT
}

final iconValues = EnumValues({
    "clear-day": Icon.CLEAR_DAY,
    "clear-night": Icon.CLEAR_NIGHT,
    "cloudy": Icon.CLOUDY,
    "partly-cloudy-day": Icon.PARTLY_CLOUDY_DAY,
    "partly-cloudy-night": Icon.PARTLY_CLOUDY_NIGHT
});

enum Preciptype {
    RAIN
}

final preciptypeValues = EnumValues({
    "rain": Preciptype.RAIN
});

enum Source {
    COMB,
    FCST,
    OBS
}

final sourceValues = EnumValues({
    "comb": Source.COMB,
    "fcst": Source.FCST,
    "obs": Source.OBS
});

enum Id {
    D5621,
    EGLC,
    EGLL,
    EGWU,
    F6665
}

final idValues = EnumValues({
    "D5621": Id.D5621,
    "EGLC": Id.EGLC,
    "EGLL": Id.EGLL,
    "EGWU": Id.EGWU,
    "F6665": Id.F6665
});

class Station {
    final double distance;
    final double latitude;
    final double longitude;
    final int useCount;
    final Id id;
    final String name;
    final int quality;
    final double contribution;

    Station({
        required this.distance,
        required this.latitude,
        required this.longitude,
        required this.useCount,
        required this.id,
        required this.name,
        required this.quality,
        required this.contribution,
    });

    // Dart
    factory Station.fromJson(Map<String, dynamic> json) => Station(
        distance: (json["distance"] as num?)?.toDouble() ?? 0.0,
        latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
        longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
        useCount: json["useCount"] ?? 0,
        id: idValues.map[json["id"]] ?? Id.D5621,
        name: json["name"] ?? "",
        quality: json["quality"] ?? 0,
        contribution: (json["contribution"] as num?)?.toDouble() ?? 0.0,
    );

    Map<String, dynamic> toJson() => {
        "distance": distance,
        "latitude": latitude,
        "longitude": longitude,
        "useCount": useCount,
        "id": idValues.reverse[id],
        "name": name,
        "quality": quality,
        "contribution": contribution,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}