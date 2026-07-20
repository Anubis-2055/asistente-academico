package com.uteq.asistente_academico.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import java.util.concurrent.TimeUnit;

@Service
public class RedisService {

    @Autowired
    private RedisTemplate<String, String> redisTemplate;

    public void agregarTokenBlacklist(String token, long tiempoExpiracion) {
        redisTemplate.opsForValue().set(
                "blacklist:" + token,
                "revocado",
                tiempoExpiracion,
                TimeUnit.MILLISECONDS
        );
    }

    public boolean estaEnBlacklist(String token) {
        return Boolean.TRUE.equals(redisTemplate.hasKey("blacklist:" + token));
    }
}