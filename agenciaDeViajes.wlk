object guia {
    method estaCalificado(unCoordinador) = unCoordinador.estaMotivado()
}

object asistenteLogistico {
    method estaCalificado(unCoordinador) = unCoordinador.aniosDeExperiencia() >= 3
}

object acompaniante {
    method estaCalificado(unCoordinador) = true
}

class Coordinador {
    var cantidadViajesRealizados = 0
    var estaMotivado
    var rol
    var aniosDeExperiencia
    const rolesPermitidos = [guia, acompaniante, asistenteLogistico]

    method cantidadViajesRealizados() = cantidadViajesRealizados
    method estaMotivado() = estaMotivado
    method aniosDeExperiencia() = aniosDeExperiencia
    method rol() = rol

    method cambiarDeRol(nuevoRol) {
        if (rolesPermitidos.contains(nuevoRol)) {
            rol = nuevoRol
        } else {
            self.error("Rol Invalido")
        }
    }

    method esAltamenteCalificado() {
        return cantidadViajesRealizados >= 20 and rol.estaCalificado(self)
    }
}

class BeneficioEspecial {
    var tipo
    var costo
    var estaVigente

    method tipo() = tipo
    method costo() = costo
    method estaVigente() = estaVigente

    method cambiarTipo(nuevoTipo) {
        tipo = nuevoTipo
    }

    method cambiarCosto(nuevoCosto) {
        costo = nuevoCosto
    }

    method cambiarVigencia() {
        estaVigente = not estaVigente
    }
}

class Pack {
    var duracionDias
    var coordinadorACargo
    var precioBase
    const beneficiosEspeciales = []

    method duracionDias() = duracionDias
    method precioBase() = precioBase
    method beneficiosEspeciales() = beneficiosEspeciales
    method coordinadorACargo() = coordinadorACargo

    method agregarBeneficio(beneficio) {
        beneficiosEspeciales.add(beneficio)
    }

    method quitarBeneficio(beneficio) {
        beneficiosEspeciales.remove(beneficio)
    }

    method precioFinal() {
        return precioBase + self.precioTotalBeneficiosVigentes()
    }

    method precioTotalBeneficiosVigentes(){
        return self.beneficiosEspecialesVigentes().sum({ unBeneficio => unBeneficio.costo() })
    }

    method beneficiosEspecialesVigentes() {
        return beneficiosEspeciales.filter({ unBeneficio => unBeneficio.estaVigente() })
    }

    method cantiadadDeBeneficiosEspecialesVigentes() {
        return self.beneficiosEspecialesVigentes().size()
    }

    method esPremium()
}

class Nacional inherits Pack {
    var provinciaDestino
    const actividades = []

    method provinciaDestino() = provinciaDestino
    method actividades() = actividades

    override method esPremium() {
        return self.duracionDias() > 10 and self.coordinadorACargo().esAltamenteCalificado()
    }
}

class Internacional inherits Pack {
    var paisDestino
    var esDeInteres
    const escalas = []

    method paisDestino() = paisDestino
    method cantEscalas() = escalas.size()
    method esDeInteres() = esDeInteres

    override method precioFinal() {
        return super() * 1.20 // super() + (super() * 0.20)
    }

    override method esPremium() {
        return esDeInteres and self.duracionDias() > 20 and escalas.isEmpty()
    }
}

class Provincial inherits Nacional {
    var ciudadesAVisitar

    method ciudadesAVisitar() = ciudadesAVisitar

    method cambiarCiudadesAVisitar(nuevaCantidad) {
        ciudadesAVisitar = nuevaCantidad
    }

    override method esPremium() {
        return self.actividades().size() >= 4 and ciudadesAVisitar > 5 and self.cantiadadDeBeneficiosEspecialesVigentes() >= 3
    }

    override method precioFinal() {
        var precio = super()
        if (self.esPremium()) {
            precio = precio * 1.05
        }
        return precio
    }
}
