import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { UsuarioComercial } from './usuario-comercial.entity';

@Entity('rol_usuario')
export class RolUsuario {
  @PrimaryGeneratedColumn()
  id_rol_usuario: number;

  @Column({ length: 80 })
  nombre_rol: string;

  @Column({ length: 255, nullable: true })
  descripcion: string;

  @Column({ default: true })
  estado: boolean;

  @OneToMany(() => UsuarioComercial, (usuario) => usuario.rol)
  usuarios: UsuarioComercial[];
}
